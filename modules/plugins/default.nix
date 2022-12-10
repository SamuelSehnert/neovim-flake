{ pkgs, lib, config, ... }:
{
  imports = [
    ./nvim-tree-lua
    ./lsp
    ./treesitter
    ./gitsigns
    ./telescope
  ];
}
