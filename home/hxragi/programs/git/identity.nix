{
  config,
  ...
}:
{
  programs.git.settings = {
    user = {
      name = "hxragi";
      email = "mixintrace@gmail.com";
      signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
    gpg.format = "ssh";
    commit.gpgsign = true;
    tag.gpgsign = true;
  };
}
