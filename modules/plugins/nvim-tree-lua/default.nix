{ pkgs, lib, config, ... }:
with lib;
with builtins;

let
  cfg = config.customNeovim.plugins.nvim-tree-lua;
in
{
  options.customNeovim.plugins.nvim-tree-lua = {
    enable = mkEnableOption "Enable Nvim-Tree-Lua";
  };

  config = mkIf cfg.enable {
    customNeovim.startupPlugins = with pkgs.neovimPlugins; [
      nvim-tree-lua
    ];
    customNeovim.luaConfigRC = ''
      require("nvim-tree").setup()
    '';
  };
}
