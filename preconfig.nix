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
