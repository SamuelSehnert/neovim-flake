{
    basicConfig = {
        customNeovim = {
            viAlias = true;
            vimAlias = true;
            options = {
                syntax = true;
                mouse = "a";
                lineNumber = "relativenumber";
                wrap = false;
                autoindent = true;
            };
            keymaps.leader = " ";
            themes = {
                enable = true;
                theme = "onedark";
            };
            plugins = {
                nvim-tree-lua = {
                    enable = true;
                    webDevIcons = true;
                };
                treesitter = {
                    enable = true;
                    context = false;
                };
                gitsigns = {
                    enable = true;
                    blame = true;
                };
                telescope = {
                    enable = true;
                    fuzzyFinder = true;
                };
                lualine = {
                    enable = true;
                    icons = false;
                    seperator = "|";
                };
                latex = {
                    enable = true;
                    viewer = "zathura";
                };
                lsp = {
                    enable = true;
                    languages = {
                        nix = true;
                        python = true;
                        c = true;
                        ocaml = true;
                    };
                };
                misc = {
                    indent-blankline = {
                        enable = true;
                        char = "┊";
                    };
                    comment-nvim.enable = true;
                    vim-sleuth.enable = true;
                    vim-fugitive = true;
                    vim-rhubarb = true;
                    vim-surround = true;
                    which-key = true;
                };
            };
        };
    };
}
