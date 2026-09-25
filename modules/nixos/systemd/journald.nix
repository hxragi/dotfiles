{
  services.journald.settings.Journal = {
    Storage = "persistent";
    Compress = true;

    SystemMaxUse = "2G";
    SystemKeepFree = "10G";
    MaxRetentionSec = "1month";

    ForwardToSyslog = false;
  };
}
