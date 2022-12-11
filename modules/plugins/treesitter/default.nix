{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.customNeovim.plugins.treesitter;
in {
  options.customNeovim.plugins.treesitter = {
    enable = mkEnableOption "Enable tree-sitter";

    folding = mkEnableOption "Enable folding";
  };

  config = let
    writeIf = { c, v1, v2 ? "" }: if c then v1 else v2;
  in mkIf cfg.enable {
      customNeovim.startupPlugins = with pkgs.neovimPlugins; [
        vim-nix
        nvim-treesitter
      ];

      customNeovim.configRC = writeIf { c = cfg.folding; v1 = ''
        " Tree-sitter based folding
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
      ''; };

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

