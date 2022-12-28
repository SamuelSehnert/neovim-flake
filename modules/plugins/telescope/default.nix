{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.telescope;
in {
    options.customNeovim.plugins.telescope = {
        enable = mkEnableOption "Enable telescope";

        fuzzyFinder = mkEnableOption "Enable rip-grep for fuzzy finder";
    };

    config = mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            telescope-nvim
            telescope-fzf-native-nvim # For optimization
            plenary-nvim

            ( if cfg.fuzzyFinder then pkgs.ripgrep else null )
        ];

        customNeovim.extraKeymaps = ''
            vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<cr>", options)
            vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<cr>", options)
        '';

        customNeovim.luaConfigRC = ''
            require('telescope').setup{}
        '';
    };
}

