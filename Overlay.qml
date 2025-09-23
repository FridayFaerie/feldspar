import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panel

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

            visible: modelData.name == "eDP-1"

            property var expanded: false
            property var active: gap.height != 0

            Rectangle {
                id: gap
                width: parent.width
                height: panel.expanded ? 52 : 0 // 52 because it happened to play nice with my pixel alignment
                anchors.centerIn: parent

                Bar {
                    visible: panel.expanded
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

            GlobalShortcut {
                appid: "feldspar"
                name: "expandGap"
                description: "Expands Gap"
                onPressed: {
                    panel.expanded = !panel.expanded;
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
                    captureSource: gap.height == 0 ? null : panel.modelData
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
                    captureSource: gap.height == 0 ? null : panel.modelData
                    constraintSize.width: panel.screen.width
                    constraintSize.height: panel.screen.height
                }
            }
        }
    }
}
