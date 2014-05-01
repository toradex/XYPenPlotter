import QtQuick 1.1

Rectangle {
    id: mainRoundButton
    width: buttonSize
    height: buttonSize
    radius: buttonSize*0.5

    property color upperColor: "#46a0da"
    property color lowerColor: "#005288"
    property color borderColor: "#c8e2f4"
    property int borderSize: 10
    property int buttonSize: 180

    property string buttonLabel: "QUIT"
    property string buttonLabelState: "drawing"

    state: "STOPPED"

    signal buttonClick()

    states: [
        State {
            name: "STOPPED"
            PropertyChanges { target: mainRoundButton; upperColor: "#46a0da" }
            PropertyChanges { target: mainRoundButton; lowerColor: "#005288" }
            PropertyChanges { target: mainRoundButton; borderColor: "#c3dff2" }
            PropertyChanges { target: mainRoundButton; buttonLabel: "Start" }
            PropertyChanges { target: mainRoundButton; buttonLabelState: "Drawing" }
        },
        State {
            name: "RUNNING"
            PropertyChanges { target: mainRoundButton; upperColor: "#fe7373" }
            PropertyChanges { target: mainRoundButton; lowerColor: "#da4f4f" }
            PropertyChanges { target: mainRoundButton; borderColor: "#ffd2d2" }
            PropertyChanges { target: mainRoundButton; buttonLabel: "Pause" }
            PropertyChanges { target: mainRoundButton; buttonLabelState: "Drawing" }
        },
        State {
            name: "PAUSED"
            PropertyChanges { target: mainRoundButton; upperColor: "#ffcf00" }
            PropertyChanges { target: mainRoundButton; lowerColor: "#ffaf00" }
            PropertyChanges { target: mainRoundButton; borderColor: "#fee29f" }
            PropertyChanges { target: mainRoundButton; buttonLabel: "Continue" }
            PropertyChanges { target: mainRoundButton; buttonLabelState: "Drawing" }
        },
        State {
            name: "WORKING"
            PropertyChanges { target: mainRoundButton; upperColor: "#bcbcbc" }
            PropertyChanges { target: mainRoundButton; lowerColor: "#cccccc" }
            PropertyChanges { target: mainRoundButton; borderColor: "#ababab" }
            PropertyChanges { target: mainRoundButton; buttonLabel: "Wait..." }
            PropertyChanges { target: mainRoundButton; buttonLabelState: "Working" }
        }
    ]

    RoundButton {
        id: roundButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
/*
        buttonSize: 180
        upperColor: "#46a0da"
        lowerColor: "#005288"
        borderColor: "#c8e2f4"
        borderSize: 10
*/
        onButtonClick: {
            parent.buttonClick();
        }
    }

    Item
    {
        anchors.centerIn: parent
        height: 80
        width: parent.width

        Text {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter;
            text: buttonLabel
            font.pixelSize: 40
            font.bold: true
            style: Text.Sunken
            styleColor: "black"

            color: "white"
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter;
            text: buttonLabelState
            font.pixelSize: 20
            font.bold: false
            font.capitalization: Font.AllUppercase

            color: "#88ffffff"

        }

    }
}
