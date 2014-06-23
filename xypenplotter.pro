# Add more folders to ship with the application, here
folder_01.source = qml/XYPenPlotter
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

nomcc {
} else {
    LIBS += -lmcc
}

# Disable "the mangling of 'va_list' has changed in GCC 4.4", since we cannot do anything about it...
*-g++* {
    QMAKE_CXXFLAGS += -Wno-psabi
}

# Project Options
TEMPLATE = app
TARGET = xypenplotter
INCLUDEPATH += .
DEPENDPATH += .
MOC_DIR = .build
OBJECTS_DIR = .build
RCC_DIR = .build
UI_DIR = .build


# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    cpuinfo.cpp \
    cpuloadworker.cpp \
    xypenplottercontroller.cpp

# Installation path
target.path = /usr/bin

OTHER_FILES += \
    qml/XYPenPlotter/Button.qml \
    qml/XYPenPlotter/main.qml \
    qml/XYPenPlotter/ProgressBar.qml \
    qml/XYPenPlotter/RoundButton.qml \
    qml/XYPenPlotter/SmallRoundButton.qml

RESOURCES = resources.qrc

HEADERS += \
    cpuinfo.h \
    cpuloadworker.h \
    xypenplottercontroller.h

# Please do not modify the following two lines. Required for deployment.
include(qtquick1applicationviewer/qtquick1applicationviewer.pri)
qtcAddDeployment()

# use OpenGL where available
contains(QT_CONFIG, opengl)|contains(QT_CONFIG, opengles1)|contains(QT_CONFIG, opengles2) {
    QT += opengl
}

# disable the Wordcloud appliance (for 0.9 release)
DEFINES += NO_WORDCLOUD_APPLIANCE

# deployment on Linux
unix {
    target.path = /usr/bin
    icon.files = fotowall.png
    icon.path = /usr/share/pixmaps
    dfile.files = fotowall.desktop
    dfile.path = /usr/share/applications
    man.files = fotowall.1
    man.path = /usr/share/man/man1
    INSTALLS += target \
        icon \
        dfile \
        man
}
