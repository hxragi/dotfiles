{ lib, ... }: {
  systemd.user.services = {
    speech-dispatcher = {
      Unit.DefaultDependencies = false;
      Install.WantedBy = lib.mkForce [ ];
    };
    xdg-document-portal = {
      Unit.DefaultDependencies = false;
      Install.WantedBy = lib.mkForce [ ];
    };
  };
}
