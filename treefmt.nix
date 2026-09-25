{
  projectRootFile = "flake.nix";

  settings.excludes = [
    "secrets/*"
  ];

  programs = {
    nixfmt.enable = true;

    deadnix.enable = true;
    statix.enable = true;

    stylua = {
      enable = true;
      settings = {
        indent_type = "Spaces";
        indent_width = 2;
        column_width = 100;
      };
    };

    yamlfmt = {
      enable = true;
      settings.formatter.retain_line_breaks_single = true;
    };

    actionlint.enable = true;
  };
}
