{ pkgs, lib, config, ... }:
{
  imports = [
    ./gitsigns
    ./lsp
    ./misc
    ./nvim-tree-lua
    ./telescope
    ./treesitter
  ];
}
