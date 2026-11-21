{
  inputs,
  ...
}:
{
  flake.homeModules.dms = {
    imports = [
      inputs.dms.homeModules.dank-material-shell
      inputs.dms-plugin-registry.homeModules.dms-plugin-registry
    ];

    programs.dank-material-shell = {
      enable = true;

      systemd.enable = true;

      settings = {
        firstDayOfWeek = 1;
        theme = "dark";
        dynamicTheming = true;
        clockDateFormat = " ";
        controlCenterWidgets = {
          battery.enable = true;
          iddleInhibitor.enable = true;
        };
        soundNewNotification = false;
        dankIslandBarId = "default";
        dankIslandHomeLayout = [
          {
            id = "media";
            enabled = true;
          }
          {
            id = "weather";
            enabled = true;
          }
          {
            id = "clock";
            enabled = true;
          }
          {
            id = "status";
            enabled = false;
          }
          {
            id = "volume";
            enabled = false;
          }
        ];
        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 0;
            screenPreferences = [
              "all"
            ];
            showOnLastDisplay = true;
            leftWidgets = [
              "launcherButton"
              "workspaceSwitcher"
              "focusedWindow"
              {
                id = "voxtype";
                enabled = true;
              }
            ];
            centerWidgets = [
              "clock"
              "weather"
            ];
            rightWidgets = [
              "systemTray"
              "clipboard"
              "cpuUsage"
              "memUsage"
              "notificationButton"
              "battery"
              "controlCenterButton"
            ];
            spacing = 4;
            innerPadding = 4;
            bottomGap = 0;
            transparency = 1;
            widgetTransparency = 1;
            squareCorners = false;
            noBackground = false;
            gothCornersEnabled = false;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            borderEnabled = false;
            borderColor = "surfaceText";
            borderOpacity = 1;
            borderThickness = 1;
            fontScale = 1;
            autoHide = false;
            autoHideDelay = 250;
            openOnOverview = false;
            visible = true;
            popupGapsAuto = true;
            popupGapsManual = 4;
          }
        ];
        # Add any other settings here
      };

      plugins = {
        # Simply enable plugins by their ID (from the registry)
        # dankBatteryAlerts.enable = true;
        colorPickerDms.enable = true;
        developerUtilities.enable = true;

        voxtype.enable = true;
        voxtypeActivityOverlay.enable = true;
        # Registry key is `voxTypeOsd` (upstream typo, matches plugin.json id)
        voxTypeOsd.enable = true;

        webSearch = {
          enable = true;
          settings = {
            searchEngines = {
              aliexpress = {
                name = "Aliexpress";
                icon = "unicode:🔍";
                url = "http://www.aliexpress.com/wholesale?SearchText=%s";
                keywords = [
                  "aliex"
                ];
              };
            };
          };
        };
        screenCaptureToolbar.enable = true;
        dankKDEConnect.enable = true;
        dmsThemeSync.enable = true;
        # Add plugin-specific settings
        # mediaPlayer = {
        #   enable = true;
        #
        #   # You can only define settings here if using the home-manager module
        #   settings = {
        #     preferredSource = "spotify";
        #   };
        # };
      };

      session = {
        isLightMode = false;
        idleInhibited = true;
        weatherLocation = "Getafe, Comunidad de Madrid";
        weatherCoordinates = "40.3070639,-3.7331808";
        showThirdPartyPlugins = true;
        # Add any other session state settings here
      };

      clipboardSettings = {
        maxHistory = 25;
        maxEntrySize = 5242880;
        autoClearDays = 1;
        clearAtStartup = true;
        disabled = false;
        disableHistory = false;
        disablePersist = true;
      };
    };
  };
}
