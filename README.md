# XY Pen Plotter UI #

This is a Qt Creator project with the UI for the XY Pen Plotter Demo
first showed by Toradex at the Embedded World 2014.

The firmware is loeaded using mqxboot, which copies eCos into a
seperate part of RAM and resets the M4 core.

Graphics are loaded directly into RAM at a specific location
using mqxboot again.

## Communication ##
There are two communication variants.

### Shared Memory ###
The UI communicates using shared memory regions. The eCos firmware
polls those regions and writes commands into defined locations.

### MCC ###
The UI communicates with the eCos Firmware using MCC (multi core
communication), which is a message based communication system.

The implementation of this variant is not yet available on eCos
side.

## Build the UI for the target ##
To compile this project, you need Qt Creator 3.0 as well as a suitable
cross compile environment. The Toradex Developer website contains more
information how to setup such an environment:

http://developer.toradex.com/how-to/how-to-set-up-qt-creator-to-cross-compile-for-embedded-linux

The meta-xypenplotter OpenEmbedded Core layer includes a suitable
bitbake scripts go generate a root filesystem as well as a SDK. This
SDK uses the Qt toolchain, but also includes libmcc, in case needed
for the multi core communication.

Up to four SVG files located in /var/cache/xypenplotter/ are picked up
by the application and shown on screen.

The provided SVG is a good example which works well with the Pen
Plotter.

In order to make loading of the eCos firmware possible the linux
memory resources need to be restricted using U-Boot arguments:
Colibri VFxx # set memargs mem=240M

The touchscreen uses tslib, which need to be configured explicitly
for Qt Embedded using an environment variable on the target.
In order to make touchscreen work out of QtCreator the "Run
Environment" can be configured in the Project settings:
- QWS_MOUSE_PROTO: tslib:/dev/input/touchscreen0

Furthermore the argument "-qws" need to be set for the executable.

## Build the UI for Desktop (without MCC) ##
In order to build the UI on the Desktop, there is a qmake config
which disables linking against libmcc and enables a demo mode.

By adding
CONFIG+=nomcc
in "Additional arguments" for the qmake build step, compiling
should succeed on a Desktop configuration as well.
