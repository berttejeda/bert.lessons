## Forward

Thank you for taking the time to read through
this interactive document; this being the first of 4 parts.

I hope these hands-on, interactive lessons can reduce the startup
cost of learning and eventually mastering [Docker](https://www.docker.com).

This lab serves as a basic introduction to use of the Docker container runtime.

## The Web Terminal

If you want to take advantage of the interactive, hands-on nature of these labs,
you'll need to either already have a web terminal connection available or fire one up
yourself.

Instructions for that can be found [here](https://github.com/berttejeda/bert.bill#webterminal).

## Software Requirements

The main software required to follow this workshop is Docker.

## Installation

Docker is supported on many architectures.

Head over to [docker.com](https://www.docker.com) for installation instructions.

## Exercise 1 - Hello, world

Docker containers are in a sense similar to [chrooted](https://www.redhat.com/sysadmin/set-linux-chroot-jails) processes,
but they also provide many more features that we are going to explore.

Let's run a "hello world" example:

<pre class='clickable-code'>
docker run --name busybox-echo busybox echo "hello world"
</pre>

A breakdown of the above command:

- `docker` # Docker client binary used to interact with Docker
- `run` # Docker subcommand - runs a command in a container
- `--name busybox-echo` # Assign the container the name of busybox-echo
- `busybox` # container image used by the run command
- `echo "hello world"` # actual command to run (and arguments)

Container images carry within themselves all the needed libraries, binaries and directories in order to be able to run.

TIP: Container images could be abstracted as "the blueprint for an object",
while containers themselves are the actualization of the object into a real instance/entity.

## Exercise 2 - Interacting with running containers

You can list running containers with:

<pre class='clickable-code'>
docker ps
</pre>

Here's an example showing the likely output from the ps command:

```
CONTAINER ID        IMAGE      COMMAND        CREATED   STATUS    PORTS    NAMES
```

The fields shown in the output can be summarized as:

- **Container ID** - auto generated unique running id
- **image** - image name
- **Command** - Linux process running as the PID 1 in the container
- **Names** - user friendly name of the container

As you'll note, upon running the "hello world" example in [Excercise 1](#exercise-1-hello-world), you may **not** see any running containers.

This is expected since the entire life cycle of the command `echo "hello world"` has already finished and thus the container has stopped.

Once the command running inside the container finishes its execution, the container will stop running,
but will still be available, even if it's not listed in the output of `ps` by default.

## Exercise 3 - List all containers, including stopped ones

To list both running and stopped containers, issue the `-a` flag when invoking `docker ps`, as with:

<pre class='clickable-code'>
docker ps -a
</pre>

The output from the ps command above is likely to be similar to:

```
CONTAINER ID        IMAGE     COMMAND      CREATED   STATUS PORTS     NAMES
0395e6f047a8        busybox   "echo 'hello world'"   8 seconds ago       Exited (0) 7 seconds ago   busybox-echo
```

Stopped containers will remain available until cleaned, so let's clean this up in the next step.

### Remove stopped containers

To remove stopper containers, issue the `docker rm` command, as with:

<pre class='clickable-code'>
docker rm my_container_name_or_id
</pre>

The argument used for the rm command can be the container ID or the container name, e.g.

- `docker rm 0395e6f047a8`
- `docker rm busybox-echo`

If you prefer, it's possible to add the option `--rm` to the `run` subcommand
so that the container will be cleaned automatically as soon as
it stops its execution, as with:

<pre class='clickable-code'>
docker run --name busybox-echo --rm busybox echo "hello world"
</pre>

## Excercise 4 - Work with container Environment Variables

Let's go over the container shell environment

### Inspect the environment variables in a conatiner

<pre class='clickable-code'>
docker run --name busybox-echo --rm busybox env
</pre>

You should see output similar to:

```
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=0a0169cdec9a
HOME=/root
```

**Important:** The environment variables passed to the container may be different
on other systems and the hostname is randomized per container, unless specified differently.

### Extend the container's environment by passing variable flags as docker run arguments

You can introduce additional environment variables to a container via the `-e` flag, as with:

```
docker run --name busybox-echo --rm -e HELLO=world busybox env
```

You should see output similar to:

```
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=0a0169cdec9a
HOME=/root
HELLO=world
```

## Excercise 5 - Container Processes

### Inspect a container's process tree

```
docker run --name busybox-echo --rm busybox ps uax
```

You should see output similar to:

```
PID   USER     TIME  COMMAND
    1 root       0:00 ps uax
```

Does this mean we are running this command as root?

Technically yes, although remember, as we anticipated, this is not the actual root of your
host system but a very limited one running inside the container.

We will get back to the topic of users and security a bit later.

In fact, as you can see, the process runs in a very limited and isolated environment where
it cannot see or access all the other processes running on your machine.

## Exercise 6 - Adding host mounts

### Inspect a container filesystem

The filesystem used inside running containers is also isolated
and separated from that of the host, as illustrated:

```
docker run --name busybox-echo --rm busybox ls -l /home
```

What if we want to expose a directory on the host to a container or vice versa?

To do so, the option `-v/--volume` must be used

### Expose the current directory to the container

```
docker run --name busybox-echo --rm -v $PWD:/home busybox ls -l /home
```

In this example, the current directory, specified via $PWD, was "mounted"
from the host system in the container so that it appeared to be "/home"
inside the container!

### Expose one or more directories inside a container

To expose multiple directories the option -v/--volume must be chained

```
mkdir -p ~/somedir
touch ~/somedir/somefile{1,2,3}
```

```
docker run --name busybox-echo --rm -v $PWD:/home -v ~/somedir:/somedir busybox ls -l /home /somedir
```

## Excercise 7 - Working with Container Networking

### Inspect a container's network interfaces

Networking in Docker containers is also isolated.

Let's look at the interfaces inside a running container

```
docker run --name busybox-echo --rm busybox ifconfig
```

Now, let's demonstrate a container running a simple HTTP echo server

## Exercise 8 - Run a simple http server inside a container

```
docker run --name busybox-echo -i -t --rm -p 8080:8080 busybox \
sh -c 'while true; do \
{ echo -e "HTTP/1.1 200 OK\r\n"; echo "busybox!"; } | \
nc -l -p  8080; \
done'
```

Let's review the structure of the command we just used:

- `docker` # Docker client binary used to interact with Docker
- `run` # Docker subcommand - runs a command in a container
- `--name busybox-echo` # Assign the container the name of busybox-echo
- `-i` # Run container interactively, that is, Keep STDIN open even if not attached
- `-t` # Run container and Allocate a pseudo-TTY
- `--rm` # Automatically remove the container when it exits
- `-p 8080:8080` # Forward port 8080 on the host to port 8080 in the container
- `busybox` # container image used by the run command
- `sh -c` ... # invoke the Bourne shell (sh) with the while loop as the command

This command remains alive and attached to the current session because the
busybox echo server will keep listening for requests.
Try reaching it from a different terminal via the following command:

```
curl http://127.0.0.1:8080
```

You should see output similar to: `'busybox!'`

Press Ctrl-C in the terminal running the container to stop it.

## Excercise 9 - Daemons, a.k.a detached containers

Our last echo server example was inconvenient as it worked in
foreground so it was bound to our shell.

As you noted, if we closed our shell, the container would also die with it.

Let's fix this problem by changing our `docker run` command

### Start a detached container

```
docker run --name busybox-echo -d --rm -p 8080:8080 busybox \
sh -c 'while true; do \
{ echo -e "HTTP/1.1 200 OK\r\n"; echo "busybox!"; } | \
nc -l -p  8080; \
done'
```

The -d flag instructs Docker to start the process in the background.

Let's see if our HTTP connection still works after we close our session:

```
curl http://127.0.0.1:8080
```

Output should be similar to:

```
busybox!
```

It's still working and now we can see it running with the ps command:

```
CONTAINER ID        IMAGE     COMMAND        CREATED   STATUS    PORTSNAMES
af0cb3d329b3        busybox   "sh -c 'while true; ..."   2 seconds ago       Up 2 seconds        0.0.0.0:8080->8080/tcp   busybox-echo
```

## Excercise 10 - View logs for a running container

If we want more information about a running container we can check its logs output
using the logs command:

```
docker logs busybox-echo
```

Docker also offers the useful command inspect which retrieves all the info related to a
specific object (network, container, image, ecc):

## Exercise 11 - Inspect a container's metadata

```
docker inspect busybox-echo
```

Output should be similar to:

```
[
    {
        "Id": "9899fe8be722739ea9b155cba1699d9df86af0d7384bd757b101dea6195a25d5",
        "Created": "2020-04-17T20:42:23.080028292Z",
        "Path": "sh",
        "Args": [
  "-c",
  "while true; ...
        ],
        "State": {
  "Status": "running",
...
```

## Exercise 12 - Attach to a running container

While a container is still running, we can enter its namespaces using the `exec` command

```
docker exec -it busybox-echo sh
```

The command above will open an sh interactive
shell that we can use to peer inside the container.

As with the run command from before,

-t flag attaches terminal for interactive typing
-i flag attaches input/output from the terminal to the process

### Inspect processes inside the running container

If you followed along without problems, you should not be inside the container from the previous exercise

```
ps uax
```

Now that we have opened a new shell inside the container, let's find what process is running as PID 1.
This workflow is similar to using SSH to access a remote computer's commandline terminal.
The difference here is that when connecting to the container,
there is no remote network connection involved.
The sh process is a shell session that is started in the
container's namespaces instead of those of the host OS.

```
ps uax
```

Output should be similar to:

```
PID   USER     TIME  COMMAND
    1 root      0:00 sh -c while true; ...
   10 root      0:00 nc -l -p 8080
   16 root      0:00 sh
   21 root      0:00 ps aux
```

Detach from the container by pressing `ctrl +d`

## Exercise 13 - Attaching to a container's input

To best illustrate the impact of -i, or --interactive in the expanded version, consider this example

```
echo "hello there" | docker run --rm busybox grep hello
```

The example above won't work as the container's input is not attached to the host stdout.

The -i flag fixes just that:

```
echo "hello there" | docker run --rm -i busybox grep hello
```

Output should be similar to:

```
hello there
```

## Excercise 14 - Starting and stopping containers

It is possible to stop and start long-living containers using stop and start commands

```
docker stop busybox-echo
```

You've stopped the busybox container we've been playing with.

To start it up again, simply run:

```
docker start busybox-echo
```

The container will start up with its previously defined startup arguments.
