# Overview

The interactive lessons in this repo are to be used with
Bert's Interactive Lesson Loader, the desktop app here 
[bert.bill](https://github.com/berttejeda/bert.bill).

# WebTerminal

Every lesson rendered through the app a web-based terminal emulator component
that allows for practicing the lesson material.

These web terminals are embedded in the user interface, 
available at its footer and as a slide-in from the right (click Utils to reveal).

The underlying technology for these web terminals is [xterm.js](https://github.com/xtermjs/xterm.js/).

As such, the xterm.js component requires a websocket to a bash process.

By default, the bert.bill desktop app will attempt to connect to a local instance of the websocket via _http://127.0.0.1:5000/_.

To get this running locally, you can invoke the docker image I've prepared via: `docker run --rm -it --name aiohttp -p 5000:5000 berttejeda/aiohttp-websocket-bash:1.0.0`

The command above will automatically start the websocket 
and bash process on the container and expose the websocket on your host port 5000.

Feel free to adjust the docker run command to your need, e.g. change the port mapping, but 
be aware that the desktop app's [configuration file](https://github.com/berttejeda/bert.bill/blob/master/bill.config.yaml.example) must be adjusted to reflect any changes to the way
the websocket is accessed.