{ lib, ... }: {
  systemd.user.services.xdg-document-portal = {
    Unit.DefaultDependencies = false;
    Install.WantedBy = lib.mkForce [ ];
  };
}
