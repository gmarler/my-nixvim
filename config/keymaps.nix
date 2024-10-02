{
  globals.mapleader = " ";

  keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>w";
      action = "<cmd>update!<CR>";
      options = {
        noremap = true;
        desc = "Save";
      };
    }
  ];
}
