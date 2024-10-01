{
  plugins.neogit = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>Neogit<CR>";
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>Neogit kind=tab<CR>";
      options = {
        # silent = true;
        desc = "Status";
      };
    }
  ];
}
