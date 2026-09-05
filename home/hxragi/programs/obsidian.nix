{ pkgs, ... }: {
  programs.obsidian = {
    enable = true;
    vaults.notes.target = "documents";
    defaultSettings = {
      app = {
        showInlineTitle = false;
      };
      appearance = {
        textFontFamily = "JetBrains Mono";
        interfaceFontFamily = "JetBrains Mono";
        monospaceFontFamily = "JetBrains Mono";
      };
      communityPlugins = with pkgs.obsidianPlugins; [
        obsidian-kanban
        dataview
      ];
    };
  };
}
