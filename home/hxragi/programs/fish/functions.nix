{
  programs.fish.functions = {
    take = {
      description = "Create directory and enter it";
      body = ''
        mkdir -p $argv[1]; and z $argv[1]
      '';
    };

    extract = {
      description = "Extract common archive formats";
      body = ''
        if test (count $argv) -eq 0
            echo "Usage: extract <archive_file>"
            return 1
        end

        for file in $argv
            if not test -f "$file"
                echo "extract: '$file' is not a valid file"
                continue
            end

            bsdtar -xf "$file"
        end
      '';
    };
  };
}
