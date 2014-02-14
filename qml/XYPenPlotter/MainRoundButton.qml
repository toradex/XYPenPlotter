import QtQuick 1.1

Rectangle {
    property int buttonSize: 100
    property string buttonLabel: "QUIT"

    state: "STOPPED"

    signal buttonClick()
    onButtonClick: {
        console.log(buttonLabel + " clicked" )

        switch (state) {
        case "RUNNING":
            state = "PAUSED";
            break;
        case "PAUSED":
            state = "RUNNING";
            break;
        case "STOPPED":
            state = "RUNNING";
            break;
        }
    }

    states: [
        State {
            name: "STOPPED"
            PropertyChanges { target: roundButton; upperColor: "#46a0da" }
            PropertyChanges { target: roundButton; lowerColor: "#005288" }
            PropertyChanges { target: roundButton; borderColor: "#c3dff2" }
            PropertyChanges { target: roundButton; buttonLabel: "Start" }
        },
        State {
            name: "RUNNING"
            PropertyChanges { target: roundButton; upperColor: "#fe7373" }
            PropertyChanges { target: roundButton; lowerColor: "#da4f4f" }
            PropertyChanges { target: roundButton; borderColor: "#ffd2d2" }
            PropertyChanges { target: roundButton; buttonLabel: "Pause" }
        },
        State {
            name: "PAUSED"
            PropertyChanges { target: roundButton; upperColor: "#ffcf00" }
            PropertyChanges { target: roundButton; lowerColor: "#ffaf00" }
            PropertyChanges { target: roundButton; borderColor: "#fee29f" }
            PropertyChanges { target: roundButton; buttonLabel: "Continue" }
        }
    ]

    RoundButton {
        id: roundButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        buttonSize: 180
        upperColor: "#46a0da"
        lowerColor: "#005288"
        borderColor: "#c8e2f4"
        borderSize: 10
        buttonLabel: "Start"

        onButtonClick: {
            parent.buttonClick();
        }
    }
}
