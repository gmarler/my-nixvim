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
        # General Mapping Headings
        {
          __unkeyed-1 = "<leader>b";
          mode = "n"; # This looks incomplete
          group = "+Buffer-Related";
        }
        {
          __unkeyed-1 = "<leader>d";
          mode = "n"; # This looks incomplete
          group = "+Debug/DAP";
        }
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
        {
          __unkeyed-1 = "<leader>h";
          mode = "n"; # This looks incomplete
          group = "+Help";
        }
      ];
    };
  };
}
