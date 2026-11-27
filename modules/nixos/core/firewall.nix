{
  boot.kernelModules = [
    "nf_tables"
    "nft_ct"
    "nft_fib"
    "nft_fib_inet"
    "nft_fib_ipv4"
    "nft_fib_ipv6"
    "nft_chain_nat"
    "nft_nat"
    "nft_masq"
    "nft_reject"
    "nft_reject_inet"
  ];

  networking = {
    nftables.enable = false;

    firewall = {
      enable = true;

      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };
}
