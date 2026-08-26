{ lib, ... }: {
  systemd.user.sockets = {
    speech-dispatcher = {
      Unit.DefaultDependencies = false;
      Install.WantedBy = lib.mkForce [ ];
    };
  };
}
