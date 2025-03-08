{
  lib,
  pkgs,
  plasma-manager,
  ...
}: {
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "open";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    fonts = {
      general = {
        family = "Monaspace Nerd Font Propo";
        pointSize = 14;
      };
    };

    window-rules = [
      {
        description = "wezterm";

        match = {
          window-class = {
            value = "wezterm";
            type = "substring";
          };
          window-types = ["normal"];
        };

        apply = {
          noborder = {
            value = true;
            apply = "force";
          };
          maximizehoriz = true;
          maximizevert = true;
        };
      }
    ];

    shortcuts = {
      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          "Meta+Ctrl+Alt+L"
        ];
      }; #ksmserver

      kwin = {
        "Expose" = "Meta+,";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Windows Up" = "Meta+K";
      }; # kwin
    }; # Shortcuts
    # This is because its a pain in the ass when accidentally hitting the touchpad.
    configFile = {
      "touchpadxlibinputrc" = {
        "[Libinput][1739][52759][SYNA32A4:00 06CB:CE17 Touchpad]" = {
          "DisableEventsOnExternalMouse" = true;
        };
      };
    }; # configFile
  }; # Plasma
}
