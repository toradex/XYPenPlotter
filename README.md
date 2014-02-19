# XY Pen Plotter UI #

This is a Qt Creator project with the UI for the XY Pen Plotter Demo
first showed by Toradex at the Embedded World 2014.

To compile this project, you need Qt Creator 3.0 as well as a suitable
cross compile environment. The Toradex Developer website contains more
information how to setup such an environment:

http://developer.toradex.com/how-to/how-to-set-up-qt-creator-to-cross-compile-for-embedded-linux

The meta-xypenplotter OpenEmbedded Core layer includes a suitable
bitbake scripts go generate a root filesystem as well as a SDK. This
SDK builts on the Qt toolchain, but also includes libmcc, which is
required for the multi core communication.

Up to four SVG files located in /var/cache/xypenplotter/ are picked up
by the application and shown on screen.

The provided SVG is a good example which works well with the Pen
Plotter.

Limit the linux memory resources using U-Boot arguments:
Colibri VFxx # set memargs mem=240M

Also, to make sure the touchscreen is working on the target when
starting from QtCreater, the environment variable needs to be set:
QWS_MOUSE_PROTO to tslib:/dev/input/touchscreen0

And the Argument "-qws" need to be set for the executable.

