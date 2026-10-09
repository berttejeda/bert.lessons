## Forward

Now that you have built docker images using the bare minimum approach,
let's go over more advanced build topics.

## The Web Terminal

If you want to take advantage of the interactive, hands-on nature of these labs,
you'll need to either already have a web terminal connection available or fire one up
yourself.

Instructions for that can be found [here](https://github.com/berttejeda/bert.bill#webterminal).

## Exercise 1 - Build and Runtime Environment variables

We can pass build and runtime environment variables to our images/containers.

### Modify your hello.sh shell script

```
echo -e '''#!/bin/sh
echo "hello, $BUILD1 and $RUN1!"
''' > hello.sh
```

Dockerfile uses the ENV directive to provide environment variable:

### Modify your Dockerfile

```
echo -e '''FROM busybox
ADD hello.sh /hello.sh
RUN chmod +x /hello.sh
ENV BUILD1 Bob
ENTRYPOINT ["/hello.sh"]
''' > Dockerfile
```

### Build and run your modified image

```
docker build -t hello:v4 .
```

### Test Runtime Env Variables

```
docker run --rm -e RUN1=Alice hello:v4
```

Output should be similar to:

```
hello, Bob and Alice!
```

*Note:* variables specified at runtime take precedence over those specified at build time, i.e.

By overriding the build time variable during runtime, as with:

`docker run --rm -e BUILD1=Jon -e RUN1=Alice hello:v4`

you'll no doubt verify the behavior:

```
hello, Jon and Alice!
```

## Exercise 2 - Build Arguments

Sometimes it is helpful to supply arguments during the build process, e.g.
when user ID needs to be created inside the container.

In a nutshell::

- The .env file, is only used during a pre-processing step when working with docker-compose.yml files.

- Dollar-notation variables like $HI are substituted for values contained in an *.env* named file in the same directory.

- **ARG** is only available during the build of a Docker image (RUN etc), **not** after the image is created and containers are started from it (ENTRYPOINT, CMD).

- You can use **ARG** values to set **ENV** values to workaround that.

- **ENV** values are available to containers and to **RUN**-style commands during the Docker build starting with the line where they are introduced.

- Setting an environment variable in an intermediate container using bash (e.g. **RUN** export VARI=5 && ...)
  will not persist in the next command without a workaround ...

- An *env_file*, is a convenient way to pass many environment variables to a single command in one batch. This should not be confused with a *.env* file

- Setting **ARG** and **ENV** values leaves traces in the Docker image

- Don't use them for secrets which are not meant to stick around

- Default and dynamically-set **ARG** values can be looked at by other people after the image is built. For example, by using the `docker history` command

We can supply build arguments as flags to the `docker build` command as we already
did with the `docker run` command, as follows ...

### Update your Dockerfile to allow Build Arguments

```
echo -e '''FROM busybox
ADD hello.sh /hello.sh
RUN chmod +x /hello.sh
ARG BUILD1
ENV BUILD1=$BUILD1
ENTRYPOINT ["/hello.sh"]
''' > Dockerfile
```

### Build your new image

```
docker build --build-arg BUILD1="Bob" -t hello:v5 .
```

### Run your new image

```
docker run --rm -e RUN1=Alice hello:v5
```

Output should be similar to:

```
hello, Bob and Alice!
```

Read more:

- [How To Pass Environment Info During Docker Builds - Bits and Pieces](https://blog.bitsrc.io/how-to-pass-environment-info-during-docker-builds-1f7c5566dd0e)

## Exercise 3 - Build Layers and Caching

Packaging can often be slow, and Docker builds are no exception.

Downloading and installing system and application packages, compiling C extensions, building assets -- it all adds up.

In order to speed up your builds, Docker implements *caching*, i.e.
if your Dockerfile and related files haven't changed,
a rebuild can reuse some of the existing layers in your local image cache.

But in order to take advantage of this cache, you need to understand how it works.

When you build a Dockerfile, Docker will see if it can use
the cached results of previous builds
- For most commands, if the text of the command hasn't changed,
the version from the cache will be used.
- For **COPY**, it also checks that the files you're copying haven't changed.

Let's create a new workspace and run through an example.

### Create a new docker workspace

```
mkdir ~/docker-workspace-caching
cd ~/docker-workspace-caching
```

### Create your support files

```
echo -e '''flask
''' > requirements.txt
```

```
echo -e '''from flask import Flask
app = Flask(__name__)
@app.route("/")
    def hello():
        return "Hello World!"
if __name__ == "__main__":
    app.run()
''' > server.py
```

### Create your Dockerfile

```
echo -e '''FROM python:3.7-slim-buster
COPY . .
RUN pip install --quiet -r requirements.txt
ENTRYPOINT ["python", "server.py"]
''' > Dockerfile
```

### Build your image

Observe the output the first time we run our build command

`docker build -t caching-example1 .`

Output should be similar to:

```
Sending build context to Docker daemon   5.12kB
Step 1/4 : FROM python:3.7-slim-buster
 ---> f96c28b7013f
Step 2/4 : COPY . .
 ---> eff791eb839d
Step 3/4 : RUN pip install --quiet -r requirements.txt
 ---> Running in 591f97f47b6e
Removing intermediate container 591f97f47b6e
 ---> 02c7cf5a3d9a
Step 4/4 : ENTRYPOINT ["python", "server.py"]
 ---> Running in e3cf483c3381
Removing intermediate container e3cf483c3381
 ---> 598b0340cc90
Successfully built 598b0340cc90
Successfully tagged example1:latest
```

### Build your image a second time

Let's try building the docker image again

`docker build -t caching-example1 .`

Output should be similar to:

```
Sending build context to Docker daemon   5.12kB
Step 1/4 : FROM python:3.7-slim-buster
 ---> f96c28b7013f
Step 2/4 : COPY . .
 ---> Using cache
 ---> eff791eb839d
Step 3/4 : RUN pip install --quiet -r requirements.txt
 ---> Using cache
 ---> 02c7cf5a3d9a
Step 4/4 : ENTRYPOINT ["python", "server.py"]
 ---> Using cache
 ---> 598b0340cc90
Successfully built 598b0340cc90
Successfully tagged example1:latest
```

Notice it mentions *Using cache*

That's because docker is utilizing the cache, as
nothing in the build has changed.

The result is a much faster build,
since we don't have to download any packages from
the network to get `pip install` to work.

To make sure we always take advantage of this great feature, we must
be careful to avoid what's known as **Cache Invalidation**

### Cache Invalidation

Cache Invalidation means:

- If the cache can't be used for a particular layer, then
- **ALL** **subsequent** layers won't be loaded from the cache

Consider the below illustration:

```
| Old Dockerfile | New Dockerfile | Use Cache? |                                             |
|:---------------|:---------------|:----------:|:--------------------------------------------|
| A              | A              |    Yes     | A == A                                      |
| B              | B_CHANGED      |     No     | B!=B_CHANGED                                |
| C              | C              |     No     | No, previous layer wasn't loaded from cache |
```

- Notice that the C layer hasn't changed between new and old Dockerfiles
- **Nonetheless**, it still can't be loaded from the cache
- **Why?** Because the previous layer (**B_CHANGED**) couldn't be loaded from the cache

If any of the files we **COPY** in change, that invalidates all later layers:
we'll need to rerun pip install, for example.

But if *server.py* has changed but *requirements.txt* hasn't,
why should we have to redo the pip install?

After all, the pip install only uses *requirements.txt*.

What you want to do therefore is to copy only those files that you actually
need in order to run the next step, so as to minimize the opportunity for cache invalidation.

Because *server.py* is only copied in after the `pip install`,
the layer created by `pip install` can still be loaded from the
cache so long as *requirements.txt* hasn't changed.

### Cache Invalidation - Summary

If you want fast builds by reusing your previously cached builds,
you'll need to write your Dockerfile appropriately:

- Only copy in the files you need for the next step, to minimize cache
  invalidation in the build process.
- Make sure not to invalidate the cache accidentally by having a
  command early in the Dockerfile that always changes.
  Examples of such commands are:
- a LABEL that contains the build timestamp
- an ENV directive that changes based on ARG

Read More:

- [Production-ready Docker packaging](https://pythonspeed.com/docker/)
- [Stuck on Docker packaging? Get up to speed quickly](https://pythonspeed.com/products/justenoughdockerpackaging/)
- [Faster or slower: the basics of Docker build caching](https://pythonspeed.com/articles/docker-caching-model/)
