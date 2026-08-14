{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "hxragi";
        email = "mixintrace@gmail.com";
      };

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        cm = "commit -m";
        lg = "log --oneline --graph --decorate";
      };

      core = {
        editor = "nvim";
        pager = "delta";
      };

      init.defaultBranch = "main";

      push.autoSetupRemote = true;
      pull.rebase = true;

      diff.algorithm = "histogram";
      merge.conflictstyle = "diff3";

      interactive.diffFilter = "delta --color-only";

      delta = {
        navigate = true;
        side-by-side = true;
      };
    };
  };
}
