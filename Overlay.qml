import Quickshell
import Quickshell.Wayland
import QtQuick
// import QtQuick.Effects
import Quickshell.Io

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panel

            WlrLayershell.layer: WlrLayer.Overlay
            implicitHeight: screen.height
            implicitWidth: screen.width

            color: "transparent"

            anchors {
                left: true
                right: true
                top: true
                bottom: true
            }

            mask: Region {
                item: Item {
                    id: mask
                    height: panel.active ? panel.screen.height : 0
                    width: panel.active ? panel.screen.width : 0
                }
            }

            property var modelData
            screen: modelData

            // visible: modelData.name == "eDP-1"

            //TODO: move to singleton
            property var delayedExpand: false
            property var copyVisible: false
            property var toggle: false
            property var active: gap.height != 0

            onToggleChanged: {
                if (toggle) {
                    expandDelay.start()
                } else {
                    closeDelay.start()
                    panel.delayedExpand = panel.toggle
                }
            }

            Rectangle {
                id: gap
                anchors.centerIn: parent
                width: parent.width
                height: panel.delayedExpand ? 52 : 0 // 52 because it happened to play nice with my pixel alignment
 
                Behavior on height {
                    NumberAnimation {
                        duration: 80
                        easing.type: Easing.InOutQuad
                    }
                }   

                Bar {
                    id: bar
                    visible: delayedExpand
                }

                color: "#2a2b36"
                // color: "white"
                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: "#90101010"
                        }
                        GradientStop {
                            position: 0.2
                            color: "transparent"
                        }
                        GradientStop {
                            position: 0.8
                            color: "transparent"
                        }
                        GradientStop {
                            position: 1.0
                            color: "#90101010"
                        }
                    }
                }
            }

            IpcHandler {
                target: "panel"
                function expand(): void {
                    panel.copyVisible = true
                    panel.toggle = !panel.toggle
                }
            }

            Timer {
                id: closeDelay
                interval: 200
                repeat: false
                onTriggered: {
                    panel.copyVisible = false
                }
            }
            Timer {
                id: expandDelay
                interval: 40 //screenshot depends on currently running things... :(
                repeat: false
                onTriggered: {
                    panel.delayedExpand = panel.toggle
                }
            }

            // NOTE: idk if I can factor this out reasonably... :(
            Rectangle {
                id: topCopy
                anchors.bottom: gap.top

                anchors.horizontalCenter: parent.horizontalCenter
                implicitWidth: panel.screen.width
                implicitHeight: panel.screen.height / 2
                clip: true
                color: "transparent"

                ScreencopyView {
                    anchors.top: parent.top

                    anchors.horizontalCenter: parent.horizontalCenter

                    live: false
                    captureSource: !panel.copyVisible ? null : panel.modelData
                    constraintSize.width: panel.screen.width
                    constraintSize.height: panel.screen.height
                }
            }
            Rectangle {
                id: bottomCopy
                anchors.top: gap.bottom

                anchors.horizontalCenter: parent.horizontalCenter
                implicitWidth: panel.screen.width
                implicitHeight: panel.screen.height / 2
                clip: true
                color: "transparent"

                ScreencopyView {
                    anchors.bottom: parent.bottom

                    anchors.horizontalCenter: parent.horizontalCenter

                    live: false
                    captureSource: !panel.copyVisible? null: panel.modelData
                    constraintSize.width: panel.screen.width
                    constraintSize.height: panel.screen.height
                }
            }
        }
    }
}
