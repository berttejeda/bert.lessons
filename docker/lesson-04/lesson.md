## Forward

The basic idea behind containers is a set of Linux resources that run isolated from the rest of the host OS.

In essence, a container is a combination of a few technologies including namespaces, cgroups, and capabilities.

You'll dig into the internals of these in the next set of exercises.

But first, some concepts ...

## The Web Terminal

If you want to take advantage of the interactive, hands-on nature of these labs,
you'll need to either already have a web terminal connection available or fire one up
yourself.

Instructions for that can be found [here](https://github.com/berttejeda/bert.bill#webterminal).

## Exercise 1 - Container foundations - Namespaces

Purpose of each namespace:

- Wrap a particular global system resource in an abstraction
- Make it appear to the processes within the namespace that they have their own isolated instance of the global resource

There are **six** types of namespaces in Linux:

1.  **Pid**: Isolates process identifiers.
    For example, two processes in different namespaces can have the same PID.
2.  **User**: Isolates user ids and group ids.
    Two users in two different user namespaces can have the same user ids.
    Allows mapping an unprivileged user id outside of the namespace to be root inside of the namespace.
3.  **Net**: This namespace provides network isolation. Processes running in a separate
    net namespace don't see the network interfaces of other namespaces.
4.  **Mnt**: The Mnt namespace creates a scoped view of a filesystem using VFS
    It allows containers to have their own mount points
    without polluting the global namespace. It also provides a way to hide the
    global mount points from other containers.
5.  **Uts**: This allows a container to have its own hostname for the processes
    running in the container.
6.  **Ipc**: Gives containers their own inter-process communication namespace.

Read more:

- [Container Creation Using Namespaces and Bash](https://dev.to/nicolasmesa/container-creation-using-namespaces-and-bash-6g)
- [Namespaces in operation, part 1: namespaces overview](https://lwn.net/Articles/531114/)
- [Use the VFS storage driver | Docker Documentation](https://docs.docker.com/storage/storagedriver/vfs-driver/)

## Exercise 2 - Container foundations - Control groups

**Control Groups** (also called cgroups) are part of a kernel feature that limits,
accounts for, and isolates resources usage (CPU, memory, disk I/O, network, etc.)
This feature is particularly useful to predict and plan for enough resources to
accommodate the desired number of containers on your systems.

Read more:

- [Container Creation Using Namespaces and Bash - DEV Community](https://dev.to/nicolasmesa/container-creation-using-namespaces-and-bash-6g)

## Exercise 3 - Container foundations - Capabilities

**Capabilities** provide enhanced permission checks on the running process,
and can limit the interface configuration, even for a root user.
For example, if CAP_NET_ADMIN is disabled, users inside a container (including root)
won't be able to manage network interfaces (add, delete, change),
change network routes and so on.

Read more:

- [Container Creation Using Namespaces and Bash - DEV Community](https://dev.to/nicolasmesa/container-creation-using-namespaces-and-bash-6g)
- [Creating containers - Part 1](http://crosbymichael.com/creating-containers-part-1.html)
