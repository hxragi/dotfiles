{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets = {
      hxragi-password = {
        neededForUsers = true;
      };

      ssh-private-key = {
        owner = "hxragi";
        mode = "0400";
        path = "/home/hxragi/.ssh/id_ed25519";
      };
    };
  };
}
