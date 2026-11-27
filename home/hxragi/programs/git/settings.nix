{
  programs.git.settings = {
    core = {
      editor = "nvim";
    };
    init.defaultBranch = "main";
    push.autoSetupRemote = true;
    pull.rebase = true;
    fetch.prune = true;
    branch.sort = "-committerdate";
    rerere.enabled = true;
    diff.algorithm = "histogram";
    merge.conflictstyle = "zdiff3";
  };
}
