{ pkgs, lib, config, ... }:
with lib;
with builtins;

let
  cfg = config.customNeovim.plugins.nvim-tree-lua;
in
{
  options.customNeovim.plugins.nvim-tree-lua = {
    enable = mkEnableOption "Enable Nvim-Tree-Lua";
    
    openOnStart = mkOption {
      default = true;
      type = types.bool;
      description = "Open when vim is started on a directory";
    };

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
      require("nvim-tree").setup({
        open_on_setup = ${boolToString cfg.openOnStart},
        open_on_setup_file = ${boolToString cfg.openOnStart},
      })
    '';
  };
}
