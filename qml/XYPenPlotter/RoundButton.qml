import QtQuick 1.1

Rectangle {
    width: buttonSize
    height: buttonSize
    radius: buttonSize*0.5
    state: "RELEASED"

    property color upperColor: "#ff7474"
    property color lowerColor: "#d94e4e"
    property color borderColor: "#d94e4e"
    property int borderSize: 1
    property int buttonSize: 100
    property string buttonLabel: "QUIT"

    signal buttonClick()
    onButtonClick: {
        console.log(buttonLabel + " clicked" )
        //colorAnimation.start()
    }

    MouseArea {
        width: buttonSize
        height: buttonSize
        id: buttonMouseArea
        onClicked: buttonClick()
        hoverEnabled: true
        onPressed: parent.state = "PRESSED"
        onReleased: parent.state = "RELEASED"
        //onEntered: parent.border.color = onHoverColor
        //onExited:  parent.border.color = borderColor
    }

    states: [
        State {
            name: "PRESSED"
            PropertyChanges { target: idUpperColor; color: lowerColor }
            PropertyChanges { target: idLowerColor; color: upperColor }
        },
        State {
            name: "RELEASED"
            PropertyChanges { target: idUpperColor; color: upperColor }
            PropertyChanges { target: idLowerColor; color: lowerColor }
        }
    ]

    transitions: [
        Transition {
            from: "PRESSED"
            to: "RELEASED"
            ColorAnimation { target: idUpperColor; duration: 100}
            ColorAnimation { target: idLowerColor; duration: 100}
        },
        Transition {
            from: "RELEASED"
            to: "PRESSED"
            ColorAnimation { target: idUpperColor; duration: 100}
            ColorAnimation { target: idLowerColor; duration: 100}
        }
    ]

    gradient: Gradient {
        GradientStop { id: idUpperColor; position: 0.0; color: upperColor }
        GradientStop { id: idLowerColor; position: 1.0; color: lowerColor }
    }



    Text {
        anchors.centerIn: parent
        text: parent.buttonLabel
        font.pixelSize: 20
        font.bold: true
        font.capitalization: Font.AllUppercase
        style: Text.Sunken
        styleColor: "black"

        color: "white"
    }

    border.width: borderSize
    border.color: borderColor
    smooth: true
}
