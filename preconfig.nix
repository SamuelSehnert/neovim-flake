{
    basicConfig = {
        customNeovim = {
            options = {
                syntax = true;
                mouse = "a";
                lineNumber = "relativenumber";
                wrap = false;
                autoindent = true;
            };
            keymaps.leader = ",";
            plugins = {
                nvim-tree-lua.enable = true;
                nvim-tree-lua.webDevIcons = true;
                treesitter.enable = true;
                gitsigns.enable = true;
                gitsigns.blame = true;
                telescope.enable = true;
                telescope.fuzzyFinder = true;
                lualine.enable = true;
                lualine.icons = true;
                latex.enable = true;
                latex.viewer = "zathura";
                latex.texMapLeader = "1";
                lsp = {
                    enable = true;
                    nix = true;
                    python = true;
                    c = true;
                };
                misc = {
                    indent-blankline = {
                        enable = true;
                        char = "┊";
                    };
                    comment-nvim.enable = true;
                    vim-sleuth.enable = true;
                };
            };
        };
    };
}
