{
    basicConfig = {
        customNeovim = {
            options = {
                colorscheme = "desert";
                syntax = true;
                mouse = "a";
                lineNumber = "relativenumber";
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
                lsp = {
                    enable = true;
                    nix = true;
                    python = true;
                    c = true;
                };
                misc = {
                    enable-indent-blankline = true;
                    enable-comment-nvim = true;
                };
            };
        };
    };
}
