import QtQuick 2.5
import QtQuick.Controls 2.0

Rectangle {
    id: root
    color: "#2e383c"

    property int stage

    Column {
        anchors.centerIn: parent
        spacing: 20

        Image {
            id: logo
            source: "images/tux.svg"
            width: 128
            height: 128
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            mipmap: true
            antialiasing: true
        }

        Rectangle {
            id: progressBarBg
            color: "#414b50"
            width: 300
            height: 4
            radius: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: progressBarFill
                color: "#a7c080"
                height: parent.height
                radius: parent.radius
                width: (parent.width / 7) * root.stage

                Behavior on width {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation {
                        from: 1
                        to: 0.6
                        duration: 800
                    }
                    NumberAnimation {
                        from: 0.6
                        to: 1
                        duration: 800
                    }
                }
            }
        }
    }
}
