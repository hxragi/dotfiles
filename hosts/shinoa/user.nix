{
  config,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;

    users.hxragi = {
      isNormalUser = true;

      extraGroups = [
        "wheel"
        "docker"
      ];

      shell = pkgs.fish;
      hashedPasswordFile = config.sops.secrets.hxragi-password.path;
    };
  };
}
