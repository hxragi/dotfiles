{
  config,
  pkgs,
  ...
}:
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-session --time --theme 'text=white;time=cyan;container=black;border=magenta;title=magenta;greet=white;prompt=blue;input=white;action=cyan;button=magenta' --cmd ${config.programs.niri.package}/bin/niri-session";

      user = "greeter";
    };
  };
}
