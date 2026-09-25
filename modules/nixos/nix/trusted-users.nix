{
  config,
  lib,
  ...
}:
{
  # Anyone who can sudo can already escalate to root, so granting the same nix
  # privileges without a second password prompt costs nothing in isolation and
  # saves a prompt on every `nix-collect-garbage`. Membership is derived from
  # `wheel` rather than a hardcoded user name, so a second host picks this up
  # automatically.
  nix.settings.trusted-users = lib.mkForce (
    [
      "root"
    ]
    ++ lib.concatMap (user: lib.optional (lib.elem "wheel" user.extraGroups) user.name) (
      lib.attrValues config.users.users
    )
  );
}
