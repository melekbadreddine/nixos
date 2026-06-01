{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.quickshell];

  home.file.".config/quickshell/shell.qml".text = ''
    import QtQuick
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Widgets

    ShellRoot {
      Variants {
        model: Quickshell.screens

        PanelWindow {
          id: root
          property var modelData: modelData
          screen: modelData

          WlrLayershell.namespace: "quickshell:bar"
          WlrLayershell.layer: WlrLayer.Top

          anchors {
            top: true
            left: true
            right: true
          }
          height: 36
          color: "transparent"

          Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            radius: 8
            color: "#${config.lib.stylix.colors.base00}"
            border.color: "#${config.lib.stylix.colors.base01}"
            border.width: 1

            Row {
              anchors.fill: parent
              anchors.leftMargin: 12
              anchors.rightMargin: 12
              spacing: 12

              Text {
                text: "  "
                color: "#${config.lib.stylix.colors.base0B}"
                font.pixelSize: 18
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
              }

              Text {
                text: "MangoWC"
                color: "#${config.lib.stylix.colors.base05}"
                font.pixelSize: 14
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
              }

              Item { width: 10 } # Spacer

              # Basic Clock
              Text {
                id: clock
                text: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
                color: "#${config.lib.stylix.colors.base05}"
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter

                Timer {
                  interval: 1000
                  running: true
                  repeat: true
                  onTriggered: clock.text = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
                }
              }

              # Flexible spacer to push items to the right
              Item {
                Layout.fillWidth: true
                width: parent.width - 400
              }

              # System Info (Placeholder for Noctalia style)
              Row {
                spacing: 15
                anchors.verticalCenter: parent.verticalCenter

                Text {
                  text: "󰍛 12%"
                  color: "#${config.lib.stylix.colors.base0D}"
                  font.pixelSize: 13
                }
                Text {
                  text: "󰻠 24%"
                  color: "#${config.lib.stylix.colors.base0E}"
                  font.pixelSize: 13
                }
                Text {
                  text: "󰁹 98%"
                  color: "#${config.lib.stylix.colors.base0A}"
                  font.pixelSize: 13
                }
              }
            }
          }
        }
      }
    }
  '';
}
