{
  services.resolved = {
    enable = true;

    settings.Resolve = {
      LLMNR = false;
      MulticastDNS = false;
      DNSSEC = "allow-downgrade";
      DNSOverTLS = "no";
    };
  };
}
