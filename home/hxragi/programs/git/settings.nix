{
  programs.git.settings = {
    core = {
      editor = "nvim";
    };
    init.defaultBranch = "main";
    push.autoSetupRemote = true;
    pull.rebase = true;
    diff.algorithm = "histogram";
    merge.conflictstyle = "diff3";
  };
}
