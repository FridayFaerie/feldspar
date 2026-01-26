import QtQuick
import Quickshell

Rectangle {
    width: parent.width
    height: parent.height

    color: "transparent"
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    Text {
        id: text

        anchors.centerIn: parent
        color: "white"
        scale: 2
        text: Qt.formatDateTime(clock.date, "hh:mm A - dd/MM/yyyy")
    }
}
