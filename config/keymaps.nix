{
  globals.mapleader = " ";

  keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>w";
      action = "<cmd>update!<CR>";
      options = {
        noremap = true;
        desc = "Save File";
      };
    }

    # Quit/Session
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>quitall<cr><esc>";
      options = {
        silent = true;
        desc = "Quit All";
      };
    }

    {
      mode = "n";
      key = "<leader>qs";
      action = ":lua require('persistence').load()<cr>";
      options = {
        silent = true;
        desc = "Restore Session";
      };
    }

        {
      mode = "n";
      key = "<leader>ql";
      action = "<cmd>lua require('persistence').load({ last = true })<cr>";
      options = {
        silent = true;
        desc = "Restore last session";
      };
    }

    {
      mode = "n";
      key = "<leader>qd";
      action = "<cmd>lua require('persistence').stop()<cr>";
      options = {
        silent = true;
        desc = "Don't save current session";
      };
    }
  ];
}
