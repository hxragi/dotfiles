{ lib, ... }:
let
  units = [
    "dbus-org.bluez.obex.service"
    "obex.service"
    "xdg-document-portal.service"
  ];
in
{
  home.activation.maskUnits =
    lib.hm.dag.entryAfter
      [
        "writeBoundary"
        ''
          mkdir -p "$HOME/.config/systemd/user"
        ''
      ]
      (
        lib.concatMapStrings (unit: ''
          if [[ -e "$HOME/.config/systemd/user/${unit}" && ! -L "$HOME/.config/systemd/user/${unit}" ]]; then
            run rm -f "$HOME/.config/systemd/user/${unit}"
          fi

          if [[ ! -e "$HOME/.config/systemd/user/${unit}" ]]; then
            run ln -s /dev/null "$HOME/.config/systemd/user/${unit}"
          fi
        '') units
      );
}
