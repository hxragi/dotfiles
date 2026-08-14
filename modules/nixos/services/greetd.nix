{
  config,
  pkgs,
  ...
}: {
  console.colors = [
    "45475a"
    "f38ba8"
    "a6e3a1"
    "f9e2af"
    "89b4fa"
    "f5c2e7"
    "94e2d5"
    "bac2de"

    "585b70"
    "f38ba8"
    "a6e3a1"
    "f9e2af"
    "89b4fa"
    "cba6f7"
    "89dceb"
    "cdd6f4"
  ];

  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings.default_session = {
      command = ''
        ${pkgs.tuigreet}/bin/tuigreet \
          --remember \
          --remember-session \
          --time \
          --theme 'text=white;time=cyan;container=black;border=magenta;title=magenta;greet=white;prompt=blue;input=white;action=cyan;button=magenta' \
          --cmd ${config.programs.niri.package}/bin/niri-session
      '';

      user = "greeter";
    };
  };
}
