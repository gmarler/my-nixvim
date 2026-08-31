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
}
