{
  nix.settings = {
    # Fail fast instead of sitting on a dead router or a captive portal.
    connect-timeout = 5;

    # Abort a transfer that has made no progress, rather than leaving a build
    # hanging indefinitely on an unstable link.
    stalled-download-timeout = 120;
  };
}
