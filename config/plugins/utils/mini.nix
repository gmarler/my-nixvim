{ lib, config, ... }:
{
  plugins.mini = {
    enable = true;
    modules = {
      ai = { };
      files = {
        windows = {
          preview = true;
          width_preview = 100;
        };
      };
      icons = { };
      notify = { };
      pairs = { };
      surround = { };
      tabline = { };
      trailspace = { };
      hipatterns = { };
      # identscope = { };
      diff = { };
    };
  };
  keymaps = lib.mkIf (config.plugins.mini.enable && lib.hasAttr "files" config.plugins.mini.modules) [
    {
      mode = "n";
      key = "<leader>fE";
      action = ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>";
      options = {
        desc = "Open file explorer in Current File cwd";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fe";
      action = ":lua MiniFiles.open(vim.loop.cwd())<CR>";
      options = {
        desc = "Open file explorer in Editor cwd";
        silent = true;
      };
    }
  ];
}
