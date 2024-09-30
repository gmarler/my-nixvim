{
  # Examples taken from: https://github.com/redyf/Neve/blob/main/config/utils/whichkey.nix
  plugins.which-key = {
    enable = true;
    settings = {
      icons = {
        breadcrumb = "»";
        group = "+";
        separator = ""; # ➜
      };
      spec = [
        # General Mappings
        {
          __unkeyed-1 = "<leader>f";
          mode = "n"; # This looks incomplete
          group = "+Find/File";
        }
        {
          __unkeyed-1 = "<leader>g";
          mode = [ "n" "v" ];
          group = "+Git";
        }
      ];
    };
  };
}
