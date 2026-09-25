{
  projectRootFile = "flake.nix";

  settings.excludes = [
    # SOPS ciphertext. Reformatting a secrets file is never wanted and buys
    # nothing, since the values are encrypted base64 anyway.
    "secrets/*"
  ];

  programs = {
    nixfmt.enable = true;

    # deadnix and statix also run as the standalone `checks.lint` gate, but
    # wiring them in here means `nix fmt` also normalises what they report.
    deadnix.enable = true;
    statix.enable = true;

    # The Lua config under home/.config/nvim/lua is hand-written, so without
    # this it was the one language in the repo no tool ever touched. Indent and
    # width are pinned to .editorconfig rather than StyLua's tabbed defaults.
    stylua = {
      enable = true;
      settings = {
        indent_type = "Spaces";
        indent_width = 2;
        column_width = 100;
      };
    };

    # retain_line_breaks_single keeps the blank lines that separate top-level
    # keys, which is the difference between a readable workflow file and a
    # solid wall of YAML.
    yamlfmt = {
      enable = true;
      settings.formatter.retain_line_breaks_single = true;
    };

    # Lints the GitHub Actions workflows, which are YAML but not covered by
    # either nixfmt or yamlfmt.
    actionlint.enable = true;
  };
}
