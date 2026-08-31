{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "pairup.nvim";
  version = "0-unstable-2026-06-07";

  src = pkgs.fetchFromGitHub {
    owner = "Piotr1215";
    repo = "pairup.nvim";
    rev = "a4841094a58bb9d42591f3c7085411b1ea87a66a";
    hash = "sha256-vBOfCsiGxDpKEN6okSaMEZ9iBvFwxhEUUnyeoFqDGyI=";
  };

  # session:start() stashes the current buffer, swaps in the terminal buffer so
  # termopen() can attach to it, then swaps back. If the stashed buffer had
  # 'bufhidden=wipe' (mini-starter's dashboard, for one) it is gone by then and
  # the restore throws "Invalid buffer id". Reported upstream; unfixed at HEAD.
  postPatch = ''
    substituteInPlace lua/pairup/core/session.lua \
      --replace-fail \
        'vim.api.nvim_set_current_buf(orig_buf)' \
        'if vim.api.nvim_buf_is_valid(orig_buf) then
          vim.api.nvim_set_current_buf(orig_buf)
        else
          vim.cmd.enew()
        end'
  '';
}
