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

        # LSP
        nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
        rnix-lsp = { url = "github:nix-community/rnix-lsp"; flake = true; };
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
            };

            keymaps.leader = ",";
            keymaps.silent = false;

            plugins = {
              nvim-tree-lua = {
                enable = true;
              };
              lsp = {
                enable = true;
                nix.enable = true;
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
