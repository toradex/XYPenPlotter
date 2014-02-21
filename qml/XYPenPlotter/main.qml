import QtQuick 1.1

Rectangle {
    id: mainRectangle
    width: 1024
    height: 600
    color: "#f1f1f1"

    Image {
        id: background
        width: parent.width
        height: parent.height
        fillMode: Image.Tile
        source: "qrc:///background.png"

    }

    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: parent.height;

        /* Header Row */

        Row {
            id: header
            width: parent.width
            height: 90

            Rectangle {
                property real lineOpacity: 0.1

                id: headerBackground
                height: parent.height
                width: parent.width
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#0067ab" }
                    GradientStop { position: 1.0; color: "#005289" }
                }


                Component.onCompleted: {
                    /* Create horizontal/vertical lines dynamically */
                    for(var i=4; i < height; i+= 5)
                    {
                        Qt.createQmlObject('import QtQuick 1.1; Rectangle { height: 1; width: parent.width; \
                            x: 0; y: ' + i + '; color: "white"; opacity: parent.lineOpacity; parent: headerBackground }',
                             headerBackground);
                    }
                    for(i=3; i < width; i+= 5)
                    {
                        Qt.createQmlObject('import QtQuick 1.1; Rectangle { height: parent.height; width: 1; \
                            x: ' + i + '; y: 0; color: "white"; opacity: parent.lineOpacity; parent: headerBackground }',
                             headerBackground);
                    }

                }


                Image {
                    id: toradexLogo
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 20

                    width: 211; height: 48;
                    source: "qrc:///toradex-logo-white.png"
                }

                Item
                {
                    anchors.top: parent.top
                    anchors.topMargin: 20

                    anchors.left: toradexLogo.right
                    anchors.leftMargin: 50

                    Rectangle {
                        width: 2
                        height: 50
                        color: "#c1d72e"

                    }

                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: -10 /* why? */

                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        text: qsTr("Colibri Vybrid VF61 Real-Time Demo")
                        font.bold: true
                        style: Text.Raised
                        styleColor: "black"
                        font.pixelSize: 30
                        color: "white"
                    }

                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 28

                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        text: qsTr("XY Pen Plotter")
                        font.bold: true
                        style: Text.Raised
                        styleColor: "black"
                        font.pixelSize: 20
                        color: "white"
                    }
                }

            }

        }

        /* Main UI Row */
        Row
        {
            height: parent.height - header.height
            width: parent.width - 30
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: header.bottom

            /* Column picture... */
            Column {
                id: columnPicture
                height: parent.height;
                anchors.top: parent.top
                anchors.topMargin: 20
                width: 500


                Item {
                    /* Placeholder for image */
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 360
                    width: 410
                    Image {
                        id: selectedPictureBackground;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.verticalCenter: parent.verticalCenter;

                        width: 410; height: 310
                        source: "qrc:///background_image.png"

                        Image {
                            id: selectedPicture;
                            width: parent.width
                            height: parent.height
                            source: "/var/cache/xyplotter/image0.svg"


                            function selectImage (picture) {
                                console.log("Selected picture: " + picture.source)

                                /* Switch picture... */
                                var tmp = selectedPicture.source;
                                selectedPicture.source = picture.source
                                picture.source = tmp;

                                /* Notify Pen Plotter controller about this change... */
                                ppController.selectImage(picture.source)
                            }
                        }

                        SequentialAnimation {
                            id: startAnimation
                            ParallelAnimation {
                                NumberAnimation {
                                    target: selectedPictureBackground
                                    properties: "width"
                                    from: selectedPictureBackground.width
                                    to: 0.0
                                    duration: 2000
                                    easing
                                    {
                                        type: Easing.InQuart;
                                    }
                               }
                                NumberAnimation {
                                    target: selectedPictureBackground
                                    properties: "height"
                                    from: selectedPictureBackground.height
                                    to: 0.0
                                    duration: 2000
                                    easing
                                    {
                                        type: Easing.InQuart;
                                    }
                               }
                           }
                           ParallelAnimation  {
                               NumberAnimation {
                                   target: selectedPictureBackground
                                   properties: "opacity"
                                   from: 1.0
                                   to: 0.0
                                   duration: 0
                               }
                               PropertyAnimation {
                                   target: selectedPictureBackground
                                   property: "width"
                                   to: selectedPictureBackground.width
                                   duration: 0
                               }
                               PropertyAnimation {
                                   target: selectedPictureBackground
                                   property: "height"
                                   to: selectedPictureBackground.height
                                   duration: 0
                               }

                           }

                           NumberAnimation {
                               target: selectedPictureBackground
                               properties: "opacity"
                               from: 0.0
                               to: 1.0
                               duration: 4000
                           }

                       }
                    }
                }

                Item {
                    id: imageStrip

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 400
                    height: 85


                    Image {
                        anchors.left: parent.left

                        width: 110
                        height: parent.height
                        source: "qrc:///background_image_small.png"

                        Image {
                            id: picture1
                            anchors.centerIn: parent
                            width: 100
                            height: 75
                            smooth: true
                            source: "/var/cache/xyplotter/image1.svg"
                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: selectedPicture.selectImage(parent)
                            }
                        }

                    }

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter

                        width: 110
                        height: parent.height
                        source: "qrc:///background_image_small.png"

                        Image {
                            id: picture2
                            anchors.centerIn: parent
                            width: 100
                            height: 75
                            smooth: true
                            source: "/var/cache/xyplotter/image2.svg"
                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: selectedPicture.selectImage(parent)
                            }
                        }
                    }


                    Image {
                        anchors.right: parent.right

                        width: 110
                        height: parent.height
                        source: "qrc:///background_image_small.png"

                        Image {
                            id: picture3
                            anchors.centerIn: parent
                            width: 100
                            height: 75
                            smooth: true
                            source: "/var/cache/xyplotter/image3.svg"
                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: selectedPicture.selectImage(parent)
                            }
                        }
                    }
                }

            }


            /* Column Buttons.. */
            Column {
                height: parent.height;
                width: parent.width - columnPicture.width;

                Row {
                    height: 40
                    width: parent.width
                }

                Row {

                    height: 35
                    width: parent.width

                    ProgressBarLabel {
                        id: progressText
                        text: "0%"
                        textLabel: "Drawing"
                        color: "#002a45"
                    }

                }

                Row {
                    height: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 40


                    ProgressBar {
                        id: progressBar
                        width: parent.width
                        progressFillImage: "qrc:///progressbar_blue.png"
                        borderColor: "#002a45"


                        /* This receives progress from ppController */
                        Connections {
                             target: ppController
                             onProgressUpdate: {
                                 progressBar.progress = progress;
                                 progressText.text = progress + "%";
                             }

                         }
                    }

                }


                /* Big button */
                Row {
                    height: 220
                    width: parent.width

                    CoolLine {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 80
                        height: parent.height

                        MainRoundButton {
                            id: mainButton;
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter

                            buttonSize: 180
                            buttonLabel: "Start"

                            Timer {
                                id: delayStartAnimation;
                                interval: 200
                                onTriggered: startAnimation.start();
                            }

                            onButtonClick: {
                                /* Cheat a bit by delaing animation, improves button animation on Vybrid */
                                if(ppController.isStopped())
                                    delayStartAnimation.start();
                                ppController.pressStart();
                            }

                            /* Receive printer state changes from ppController, update Button accordingly... */
                            Connections {
                                 target: ppController
                                 onStateChanged: {
                                     console.log("onStateChanged: " + newState)
                                     mainButton.state = newState;
                                 }
                             }
                        }
                    }
                }

                Row {
                    height: 35
                    width: parent.width

                    ProgressBarLabel {
                        id: cpuLoadText
                        textLabel: "CPU-Load"
                        text: "0%"
                        color: "#5c680e"
                    }
                }

                Row {
                    height: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 40


                    ProgressBar {
                        id: progressBarCpu
                        width: parent.width
                        progressFillImage: "qrc:///progressbar_green.png"
                        borderColor: "#99ac1c"
                    }

                }

                Row {
                    height: 100
                    width: parent.width

                    CoolLine {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        height: parent.height

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            spacing: 40

                            SmallRoundButton {
                                property bool isCpuLoadActive;
                                id: loadButton
                                upperColor: "#6d6d6d"
                                lowerColor: "#4a4a4a"
                                borderColor: "#dadada"
                                buttonLabel: "STRESS<br>CPU"

                                onButtonClick: {
                                    isCpuLoadActive = !isCpuLoadActive;
                                    cpuInfo.setCpuLoadActive(isCpuLoadActive);

                                    if(isCpuLoadActive)
                                        buttonLabel = "STRESS<br>OFF"
                                    else
                                        buttonLabel = "STRESS<br>CPU"

                                }
                            }

                            SmallRoundButton {
                                id: homingButton

                                borderColor: "#dadada"
                                buttonLabel: "Home"

                                onButtonClick: {
                                    //cpuInfo.shutdown();
                                    ppController.home();
                                }
                            }

                            SmallRoundButton {
                                id: sendButton
                                upperColor: "#6d6d6d"
                                lowerColor: "#4a4a4a"
                                borderColor: "#dadada"

                                buttonLabel: "Turn UI"

                                onButtonClick: {
                                    /*
                                    rotationAnimation.to += 180
                                    rotationAnimation.start()
                                    */
                                    mainRectangle.rotation += 180
                                }

                                NumberAnimation {
                                    id: rotationAnimation;
                                    target: mainRectangle;
                                    property: "rotation";
                                    duration: 5000;
                                    easing.type: Easing.InOutQuad;
                                    to: 0
                                }


                            }

                        }

                    }



                }

            }


        }
    }

    Timer {
        interval: 300; running: true; repeat: true;
        onTriggered: {
            var load = cpuInfo.getCpuLoad();
            cpuLoadText.text = load.toFixed(0) + "%";
            progressBarCpu.progress = load;
        }

    }

}
