import QtQuick 1.1

Rectangle {
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

                        text: qsTr("XY-Plotter")
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

                        text: qsTr("Demo")
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
                            source: "/var/cache/xyplotter/toradex_with_slogan_black-outlines.svg"
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
/*
                        Rectangle {
                             id: flashingblob
                             anchors.horizontalCenter: parent.horizontalCenter;
                             anchors.verticalCenter: parent.verticalCenter;
                             width: 300; height: 300
                             color: "#aaaaaa"
                             opacity: 1.0

                             NumberAnimation {
                                 id: animateOpacity
                                 target: flashingblob
                                 properties: "width, height"
                                 from: 300.0
                                 to: 0.0
                                 duration: 2000
                                 easing
                                 {
                                     type: Easing.InQuart;
                                 }
                            }
                        }*/
                    }
                }

                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 400
                    height: 75

                    Image {
                        anchors.left: parent.left

                        width: 100
                        height: parent.height
                        source: "qrc:///background_image_small.png"

                        Image {
                            id: picture1
                            width: parent.width
                            height: parent.height
                            source: "/var/cache/xyplotter/toradex_with_slogan_black-outlines.svg"
                        }

                    }

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter

                        width: 100
                        height: parent.height
                        source: "qrc:///background_image_small.png"

                        Image {
                            id: picture2
                            width: 100
                            height: parent.height
                            source: "/var/cache/xyplotter/toradex_with_slogan_black-outlines.svg"
                        }
                    }


                    Image {
                        anchors.right: parent.right

                        width: 100
                        height: parent.height
                        source: "qrc:///background_image_small.png"

                        Image {
                            id: picture3
                            width: 100
                            height: parent.height
                            source: "/var/cache/xyplotter/toradex_with_slogan_black-outlines.svg"
                        }
                    }
                }

            }


            /* Column Buttons.. */
            Column {
                height: parent.height;
                width: parent.width - columnPicture.width;


                /* Big button */
                Row {
                    height: 300
                    width: parent.width

                    CoolLine {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 80
                        height: parent.height

                        MainRoundButton {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter

                            buttonSize: 180
                            buttonLabel: "Start"

                            onButtonClick: {
                                startAnimation.start()
                            }
                        }
                    }
                }

                Row {
                    height: 20
                    width: parent.width

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "CPU-Load"
                        color: "#141414"
                    }
                }

                Row {
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 40


                    ProgressBar {
                        width: parent.width
                        id: progressBar

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 5

                            id: cpuLoadText
                            text: "0%"
                        }
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

                            RoundButton {
                                property bool isCpuLoadActive;
                                id: loadButton
                                upperColor: "#6d6d6d"
                                lowerColor: "#4a4a4a"
                                borderColor: "#dadada"
                                buttonLabel: "Load<br>on"

                                onButtonClick: {
                                    isCpuLoadActive = !isCpuLoadActive;
                                    cpuInfo.setCpuLoadActive(isCpuLoadActive);

                                    if(isCpuLoadActive)
                                        buttonLabel = "Load<br>off"
                                    else
                                        buttonLabel = "Load<br>on"

                                }
                            }
                            RoundButton {
                                id: quitButton
                                borderColor: "#dadada"

                                buttonLabel: "Quit"

                                onButtonClick: {
                                    Qt.quit();
                                }
                            }
                            RoundButton {
                                id: sendButton
                                upperColor: "#6d6d6d"
                                lowerColor: "#4a4a4a"
                                borderColor: "#dadada"

                                buttonLabel: "Send"

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
            cpuLoadText.text = load.toFixed(1);
            progressBar.progress = load;
        }

    }

}
