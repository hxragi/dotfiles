{
  config,
  lib,
  ...
}:
{
  nix.settings.trusted-users = lib.mkForce (
    [
      "root"
    ]
    ++ lib.concatMap (user: lib.optional (lib.elem "wheel" user.extraGroups) user.name) (
      lib.attrValues config.users.users
    )
  );
}
