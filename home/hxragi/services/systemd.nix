{lib, ...}: {
  systemd.user = {
    services.speech-dispatcher = {
      Unit.DefaultDependencies = false;
      Install.WantedBy = lib.mkForce [];
    };
    sockets.speech-dispatcher = {
      Unit.DefaultDependencies = false;
      Install.WantedBy = lib.mkForce [];
    };
    services.xdg-document-portal = {
      Unit.DefaultDependencies = false;
      Install.WantedBy = lib.mkForce [];
    };
  };
}
