{ironbar, ...}: {
  imports = [
    ironbar.homeManagerModules.default
  ];

  programs.ironbar = {
    enable = true;
    systemd = true;

    config = {
      position = "top";
      height = 18;

      start = [
        {
          type = "workspaces";
        }
      ];

      center = [];

      end = [
        {
          type = "tray";
        }
        {
          type = "clock";
        }
      ];
    };
  };
}
