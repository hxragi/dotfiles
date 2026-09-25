{
  # logrotate is disabled, so journald's own rotation is the only mechanism
  # bounding log growth. Docker's daemon also uses the journald log driver here,
  # which means container output counts against these limits too.
  services.journald.settings.Journal = {
    Storage = "persistent";
    Compress = true;

    SystemMaxUse = "2G";
    SystemKeepFree = "10G";
    MaxRetentionSec = "1month";

    ForwardToSyslog = false;
  };
}
