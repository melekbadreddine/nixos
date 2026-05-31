{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.quickshell];

  home.file.".config/quickshell/shell.qml".text = ''
    import QtQuick 2.15
    import Quickshell 1.0
    import Quickshell.Widgets 1.0

    ShellRoot {
      Panel {
        anchors {
          top: parent.top
          left: parent.left
          right: parent.right
        }
        height: 32
        color: "#${config.lib.stylix.colors.base00}"

        Row {
          anchors.fill: parent
          spacing: 10
          Text { text: "  "; color: "#${config.lib.stylix.colors.base0B}"; font.pixelSize: 18 }
          Text { text: "MangoWC"; color: "#${config.lib.stylix.colors.base05}"; font.pixelSize: 14 }
          Item { width: parent.width - 200 } # Spacer
          Text { text: new Date().toLocaleTimeString(); color: "#${config.lib.stylix.colors.base05}" }
        }
      }
    }
  '';
}
