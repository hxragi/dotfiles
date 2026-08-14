{pkgs, ...}: {
  home.packages = [
    pkgs.awww
  ];

  systemd.user.services.awww-daemon = {
    Unit = {
      Description = "Awww wallpaper daemon";
      After = [
        "graphical-session.target"
      ];
      PartOf = [
        "graphical-session.target"
      ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [
      "graphical-session.target"
    ];
  };
}
