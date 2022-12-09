{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.customNeovim.plugins.treesitter;
in {
  options.customNeovim.plugins.treesitter = {
    enable = mkEnableOption "Enable tree-sitter [nvim-treesitter]";
  };

  config = mkIf cfg.enable {
      customNeovim.startupPlugins = with pkgs.neovimPlugins; [
        nvim-treesitter
      ];

      customNeovim.luaConfigRC = ''
        -- Treesitter config
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            disable = {},
          },

          auto_install = false,
          ensure_isntalled = {},

          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },

        }
      '';
  };
}

