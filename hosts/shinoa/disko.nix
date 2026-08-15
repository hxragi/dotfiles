{
  disko.devices = {
    disk.main = {
      type = "disk";

      device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4cc02b2a";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            uuid = "c9841158-3356-4a32-bd5c-b550f9bddac9";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";

              mountOptions = [
                "fmask=0022"
                "dmask=0022"
              ];
            };
          };

          root = {
            size = "100%";
            uuid = "b54f4bbc-5b6d-4f3d-b3da-6229bdbe0082";

            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
