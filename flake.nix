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
        vim-nix = { url = "github:LnL7/vim-nix"; flake = false; };

        # LSP
        nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };

        # Telescope
        telescope-nvim = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
        telescope-fzf-native-nvim = { url = "github:nvim-telescope/telescope-fzf-native.nvim"; flake = false; };
        ripgrep = { url = "github:BurntSushi/ripgrep"; flake = false; };
        plenary-nvim = { url = "github:nvim-lua/plenary.nvim"; flake = false; };

        # Misc
        gitsigns-nvim = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
        indent-blankline-nvim = { url = "github:lukas-reineke/indent-blankline.nvim"; flake = false; };
    };

    outputs = inputs:
    let
        system = "x86_64-linux";

        neovimBuilder = import ./neovimBuilder.nix;

        pluginOverlay = final: prev: let

          # I find this slightly better than listing out the plugins in an array, but it's still pretty busted...
          plugins = builtins.attrNames ( builtins.removeAttrs inputs [ "nixpkgs" "neovim" "self" ] );

          buildPlug = name: final.vimUtils.buildVimPluginFrom2Nix {
            pname = name;
            version = "master";
            src = builtins.getAttr name inputs;
          }; in {
          neovimPlugins = builtins.listToAttrs (map (name: { inherit name; value = buildPlug name; }) plugins);
        };

        customPkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            pluginOverlay
            (final: prev: { neovim-unwrapped = inputs.neovim.packages.${prev.system}.neovim; })
          ];
        };

        basicConfig = {
          customNeovim = {

            options = {
              colorscheme = "desert";
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
                enableIndentBlankline = true;
              };
            };

          };
        };

    in rec {

      # For debugging
      # inherit plugins pluginOverlay customPkgs;

      packages.${system} = {
        preconfigured = neovimBuilder {
          pkgs = customPkgs;
          config = basicConfig;
        };
      };

      # This is how the flake can get added to another system;
      overlays.default = final: prev: {
        inherit neovimBuilder;
        preconfigured = packages.${system}.preconfigured;
        neovimPlugins = customPkgs.neovimPlugins;
      };

      # This is for $flake run. Mostly for testing
      apps.${system} = {
          default = {
              type = "app";
              program = "${packages.${system}.preconfigured}/bin/nvim";
          };
      };
    };
}
