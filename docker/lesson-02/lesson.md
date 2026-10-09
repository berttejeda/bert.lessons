## Forward

So far we have been using container images downloaded from Docker's public registry.

One of the key success factors for Docker among
competitors was the possibility to easily create,
customize, share and improve container images cooperatively.

This lab covers this feature in detail.

## The Web Terminal

If you want to take advantage of the interactive, hands-on nature of these labs,
you'll need to either already have a web terminal connection available or fire one up
yourself.

Instructions for that can be found [here](https://github.com/berttejeda/bert.bill#webterminal).

## Exercise 1 - Starting from scratch

If we want to start from scratch, let's build the ingredients for our container image.

### Create a hello world script

```
mkdir docker-workspace
cd docker-workspace
echo -e '''#!/bin/sh
echo "hello, world $@"
''' > hello.sh
```

### Create your Dockerfile

A Dockerfile is a special file that instructs
the docker build command on how to build an image

```
echo -e '''FROM scratch
ADD hello.sh /hello.sh
''' > Dockerfile
```

You should now have in your directory two files, Dockerfile and hello.sh

### Build your image

`docker build -t hello .`

The output should be similar to:

```
Sending build context to Docker daemon 3.072 kB
Step 1/2 : FROM scratch
 --->
Step 2/2 : ADD hello.sh /hello.sh
 ---> 03899b124d13
Successfully built 03899b124d13
Successfully tagged hello:latest
```

The Dockerfile used is very simple:

```
  FROM scratch
  ADD hello.sh /hello.sh
```

- **FROM scratch** instructs the Docker build process
  to use an empty image as the basis to build our custom container image

- **ADD hello.sh /hello.sh** adds the file hello.sh to the
  container's root path /hello.sh.

## Exercise 2 - Viewing images

Let's go over viewing docker images

### List available docker images

Run the command `docker images` to display images that we have built.

Running the above command should display image information similar to:

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello               latest              fcb780e01f47        5 minutes ago       35B
```

Here's a quick explanation of the columns shown in that output:

- **Repository** - a name associated to this image
  locally (on your computer) or on a remote repository.
  Our current repository is local and the image is called hello
- **Tag** - indicates the version of our image, Docker
  sets the *latest* tag automatically if none is specified
- **Image ID** - unique image ID
- **Size** - the size of our image is very small (~35 bytes)

NOTE: Docker images are quite different from virtual machine image formats.

Since Docker does not boot any operating system,
but simply runs Linux processes in isolation,

we don't need any kernel-level objects or drivers to ship with an image,

so the size can potentially be as tiny as just a few bytes!

## Exercise 3 - Running our image

Let's go over *running* our image, i.e. invoking our image as a container ...

### Run the newly-built image

```
docker run --rm hello /hello.sh
```

As you'll note, trying to run our newly built image
will result in an error similar to one of the following (depending on your version of Docker):

```
write pipe: bad file descriptor
```

or

```
standard_init_linux.go:211: exec user process caused "no such file or directory"
```

This is because our container is empty.

There is no shell, so the script won't be able to start!

Let's fix that by changing our base image to *busybox*, as
it contains a proper shell environment ...

## Exercise 4 - Rebuilding the image

Time to rebuild our docker image.

### Recreate your Dockerfile using busybox as your base image

```
echo -e '''FROM busybox
ADD hello.sh /hello.sh
RUN chmod +x /hello.sh
''' > Dockerfile
```

### Build your container again

`docker build -t hello .`

The output should be similar to:

```
Sending build context to Docker daemon  6.144kB
Step 1/3 : FROM busybox
 ---> be5888e67be6
Step 2/3 : ADD hello.sh /hello.sh
 ---> Using cache
 ---> a54d28b10018
Step 3/3 : RUN chmod +x /hello.sh
 ---> Using cache
 ---> befa8400f441
Successfully built befa8400f441
Successfully tagged hello:latest
```

Again, the Dockerfile used is very simple:

```
  FROM busybox
  ADD hello.sh /hello.sh
  RUN chmod +x /hello.sh
```

- **FROM busybox** instructs the Docker build process
  to use the busybox public docker image as the
  basis to build our custom container image

- **ADD hello.sh /hello.sh** adds the file hello.sh
  to the container's root path /hello.sh.

- **RUN chmod +x /hello.sh** sets the execution bit on the hello.sh
  script to make it executable.

Listing the image should show that image ID and size have changed.

### List available docker images

Running `docker images` should produce output similar to:

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello               latest              2a56d704ff5b        43 seconds ago      1.22MB
<none>              <none>              f94453b3174d        9 minutes ago       34B
busybox             latest              be5888e67be6        2 weeks ago         1.22MB
```

We should be able to run our container now.

### Run your rebuilt image

```
docker run --rm hello /hello.sh  <%= $env:Username %>
```

Output should be similar to:

```
hello, world <%= $env:Username %>
```

## Exercise 5 - Versioning your image

Let's roll out a new version of our script

### Modify your hello world script

```
echo -e '''#!/bin/sh
echo "hello, world $@"
echo "I am a new image"
''' > hello.sh
```

We don't need to update our Dockerfile, as it references the same script.

We just have to rebuild the image.

### Build your image again, this time with a new tag

`docker build -t hello:v2 .`

### Run your v2 image

```
docker run --rm hello:v2 /hello.sh <%= $env:Username %>
```

Output should be similar to:

```
hello, world <%= $env:Username %>
I'm a new image
```

## Exercise 6 - Entry points

We can improve our image by supplying an entrypoint.

This will set the default command executed if none is specified
when starting the container.

### Define an entrypoint for your image

```
echo -e '''FROM busybox
ADD hello.sh /hello.sh
RUN chmod +x /hello.sh
ENTRYPOINT ["/hello.sh"]
''' > Dockerfile
```

### Build a new version of your image

```
docker build -t hello:v3 .
```

We should now be able to run the new image
version without supplying additional arguments

### Run your v3 image

```
docker run --rm hello:v3
```

Output should be similar to:

```
hello, world
I am a new image
```

What happens if you pass an additional argument as in previous examples?

These will be passed to the **ENTRYPOINT** command as arguments.

### Run your v3 image with arguments

```
docker run --rm hello:v3 testing
```

Read more:

- [workshop/docker.md at master · gravitational/workshop](https://github.com/gravitational/workshop/blob/master/docker.md)
