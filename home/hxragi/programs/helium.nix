{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.helium.homeModules.default
  ];

  programs.helium = {
    enable = true;
    package = pkgs.helium;
    policies = {
      "BrowserSignin" = 0;
      "PasswordManagerEnabled" = false;
      "SyncDisabled" = true;
      "SpellcheckEnabled" = false;
    };
  };
}
