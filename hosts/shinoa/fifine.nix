{ pkgs, ... }: {
  services.pipewire = {
    wireplumber.extraConfig."10-fifine-mic" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "device.name" = "alsa_card.usb-3142_Fifine_Microphone-00";
            }
          ];

          actions.update-props = {
            "api.alsa.soft-mixer" = true;
          };
        }
        {
          matches = [
            {
              "node.name" = "alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback";
            }
          ];

          actions.update-props = {
            "priority.session" = 1;
            "priority.driver" = 1;
          };
        }
      ];
    };

    extraConfig.pipewire."10-fifine-rnnoise" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Fifine Noise Canceling";
            "media.name" = "Fifine Noise Canceling";
            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  label = "noise_suppressor_mono";
                  control = {
                    "VAD Threshold (%)" = 25.0;
                    "VAD Grace Period (ms)" = 250;
                    "Retroactive VAD Grace (ms)" = 20;
                  };
                }
                {
                  type = "builtin";
                  name = "gain";
                  label = "mixer";
                  control = {
                    "Gain 1" = 1.3;
                  };
                }
              ];
              links = [
                {
                  output = "rnnoise:Output";
                  input = "gain:In 1";
                }
              ];
              inputs = [ "rnnoise:Input" ];
              outputs = [ "gain:Out" ];
            };
            "capture.props" = {
              "node.name" = "capture.rnnoise_source";
              "node.passive" = true;
              "audio.channels" = 1;
              "audio.position" = [ "MONO" ];
              "audio.rate" = 48000;
              "stream.dont-remix" = true;
              "target.object" = "alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback";
            };
            "playback.props" = {
              "node.name" = "rnnoise_source";
              "media.class" = "Audio/Source";
              "audio.channels" = 1;
              "audio.position" = [ "MONO" ];
              "audio.rate" = 48000;
              "priority.session" = 2500;
              "priority.driver" = 2500;
            };
          };
        }
      ];
    };
  };
}
