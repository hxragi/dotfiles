{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono:size=20";
        width = 45;
        lines = 7;
        horizontal-pad = 15;
        vertical-pad = 15;
        inner-pad = 15;
        prompt = "run: ";
        icons-enabled = "no";
      };

      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        prompt = "bac2deff";
        placeholder = "7f849cff";
        input = "cdd6f4ff";
        match = "74c7ecff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "74c7ecff";
        border = "74c7ecff";
      };

      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}
