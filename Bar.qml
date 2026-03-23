import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    width: parent.width
    height: parent.height
    anchors.centerIn: parent

    property var update: false

    onUpdateChanged: {
      if (update == true) {
        battery.running = true;
        update = false;
      }
    }
    
    Process {
        id: battery
        property int percentage: 0
        running: true
        command: [ "cat", "/sys/class/power_supply/BAT0/capacity" ]
        stdout: StdioCollector {
                onStreamFinished: {
                        battery.percentage = this.text
                }
          }
}

    color: "transparent"
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    Text {
        id: batterydisp
        anchors {
              right: parent.right
              verticalCenter: parent.verticalCenter
        }
        color: "#c0c0c0"
        text: battery.percentage + "% "
	font.family: "JetBrainsMono Nerd Font Propo"
        font.pointSize: 15
    }
    Text {
        id: clockdisp
        anchors.centerIn: parent
        color: "#c0c0c0"
        text: Qt.formatDateTime(clock.date, "hh:mm A - dd/MM/yyyy")
        // text: Qt.formatDateTime(clock.date, "00:mm 'AM' - 31/MM/yyyy")
	font.family: "JetBrainsMono Nerd Font Propo"
        font.pointSize: 15
    }
}
