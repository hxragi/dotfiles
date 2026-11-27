{
  config,
  pkgs,
  ...
}:
{
  users = {
    mutableUsers = false;

    users.hxragi = {
      isNormalUser = true;

      extraGroups = [
        "wheel"
        "podman"
      ];

      shell = pkgs.fish;
      hashedPasswordFile = config.sops.secrets.hxragi-password.path;
    };
  };
}
