# https://github.com/Quoteme/neovim-flake/blob/master/flake.nix
{
    description = "test";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        neovim = {
            url = "github:neovim/neovim?dir=contrib";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # File Tree
        nvim-tree-lua = { url = "github:nvim-tree/nvim-tree.lua"; flake = false; };
        nvim-web-devicons = { url = "github:nvim-tree/nvim-web-devicons"; flake = false; };

        # Tree-sitter https://github.com/nvim-treesitter/nvim-treesitter
        nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
        nvim-treesitter-context = { url = "github:nvim-treesitter/nvim-treesitter-context"; flake = false; };
        vim-nix = { url = "github:LnL7/vim-nix"; flake = false; };

        # LSP
        nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };

        # Autocomplete
        nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
        cmp-nvim-lsp = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
        luaSnip = { url = "github:L3MON4D3/LuaSnip"; flake = false; };
        cmp_luasnip = { url = "github:saadparwaiz1/cmp_luasnip"; flake = false; };

        # Telescope
        telescope-nvim = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
        telescope-fzf-native-nvim = { url = "github:nvim-telescope/telescope-fzf-native.nvim"; flake = false; };
        ripgrep = { url = "github:BurntSushi/ripgrep"; flake = false; };
        plenary-nvim = { url = "github:nvim-lua/plenary.nvim"; flake = false; };

        # Status Line
        lualine-nvim = { url = "github:nvim-lualine/lualine.nvim"; flake = false; };

        # Latex
        vimtex = { url = "github:lervag/vimtex"; flake = false; };

        # Misc
        gitsigns-nvim = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
        indent-blankline-nvim = { url = "github:lukas-reineke/indent-blankline.nvim"; flake = false; };
        comment-nvim = { url = "github:numToStr/Comment.nvim"; flake = false; };
        vim-sleuth = { url = "github:tpope/vim-sleuth"; flake = false; };
        vim-fugitive = { url = "github:tpope/vim-fugitive"; flake = false; };
        vim-rhubarb = { url = "github:tpope/vim-rhubarb"; flake = false; };
        vim-surround = { url = "github:tpope/vim-surround"; flake = false; };
        vim-repeat = { url = "github:tpope/vim-repeat"; flake = false; };
        which-key = { url = "github:folke/which-key.nvim"; flake = false; };
    };

    outputs = inputs: let
        system = "x86_64-linux";

        lib = import ./lib;

        pluginOverlay = final: prev: let
            # I find this slightly better than listing out the plugins in an array, but it's still pretty busted...
            plugins = builtins.attrNames ( builtins.removeAttrs inputs [ "nixpkgs" "neovim" "self" ] );

            buildPlug = name: final.vimUtils.buildVimPluginFrom2Nix {
                pname = name;
                version = "master";
                src = builtins.getAttr name inputs;
            };
        in {
            neovimPlugins = builtins.listToAttrs (map (name: { inherit name; value = buildPlug name; }) plugins);
        };

        customPkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
                pluginOverlay
                (final: prev: { neovim-unwrapped = inputs.neovim.packages.${prev.system}.neovim; })
            ];
        };

    in rec {
        packages.${system} = rec {
            empty = lib.neovimBuilder { pkgs = customPkgs; config = {}; };
            preconfigured = lib.neovimBuilder {
                pkgs = customPkgs;
                config = (import ./preconfig.nix).basicConfig;
            };
            default = preconfigured;
        };

        # This is how the flake can get added to another system AND customize options.
        overlays.default = final: prev: {
            preconfigured = packages.${system}.preconfigured;
            neovimBuilder = lib.neovimBuilder;
            neovimPlugins = customPkgs.neovimPlugins;
        };

        # This is for $flake run. Mostly for testing
        apps.${system} = rec {
            empty = {
                type = "app";
                program = "${packages.${system}.empty}/bin/nvim";
            };
            preconfigured = {
                type = "app";
                program = "${packages.${system}.preconfigured}/bin/nvim";
            };
            default = preconfigured;
        };
    };
}
