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

    customNeovim.extraKeymaps =
      let keymapOptions = "{ noremap = true; silent = true; }";
    in
    ''
      vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<cr>", ${keymapOptions})
    '';

    customNeovim.luaConfigRC = ''
      require("nvim-tree").setup()
    '';
  };
}
