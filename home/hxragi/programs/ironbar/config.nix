{
  programs.ironbar = {
    enable = true;
    systemd = true;
    config = {
      position = "top";
      height = 24;
      start = [
        {
          type = "workspaces";
        }
      ];
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
