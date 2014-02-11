import QtQuick 1.1

Rectangle {
    width: buttonSize
    height: buttonSize
    radius: buttonSize*0.5
    color: "black";

    property color upperColor: "#ff7474"
    property color lowerColor: "#d94e4e"
    property color borderColor: "#d94e4e"
    property int borderSize: 1
    property int buttonSize: 100
    property string buttonLabel: "QUIT"

    signal buttonClick()
    onButtonClick: {
        console.log(buttonLabel + " clicked" )
    }

    MouseArea {
        width: buttonSize
        height: buttonSize
        id: buttonMouseArea
        onClicked: buttonClick()
        hoverEnabled: true
        //onEntered: parent.border.color = onHoverColor
        //onExited:  parent.border.color = borderColor
    }

    gradient: Gradient {
        GradientStop { position: 0.0; color: upperColor }
        GradientStop { position: 1.0; color: lowerColor }
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
