{pkgs, ...}: {
  home = {
    packages = [
      pkgs.neovim
    ];

    file.".config/nvim".source = ../../.config/nvim;

    sessionVariables.EDITOR = "nvim";
  };
}
