{lib, ...}: {
  home.activation.maskObex = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "$HOME/.config/systemd/user"

    run rm -f "$HOME/.config/systemd/user/obex.service"
    run ln -s /dev/null "$HOME/.config/systemd/user/obex.service"

    run rm -f "$HOME/.config/systemd/user/dbus-org.bluez.obex.service"
    run ln -s /dev/null "$HOME/.config/systemd/user/dbus-org.bluez.obex.service"
  '';
}
