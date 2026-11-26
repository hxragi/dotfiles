{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

    secrets.ssh-private-key = {
      mode = "0400";
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
  };
}
