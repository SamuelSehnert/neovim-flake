# https://github.com/Quoteme/neovim-flake/blob/master/flake.nix
{
    description = "test";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        neovim = {
            url = "github:neovim/neovim?dir=contrib";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # gruvbox = { url = "github:morhetz/gruvbox"; flake = false; };
        # nord-vim = { url = "github:arcticicestudio/nord-vim"; flake = false; };
    };

    outputs = inputs:
    let
        system = "x86_64-linux";

        neovimBuilder = import ./neovimBuilder.nix;

        pluginOverlay = final: prev:
            let
              inherit (prev.vimUtils) buildVimPluginFrom2Nix;

              plugins = builtins.attrNames (builtins.removeAttrs inputs [ "nixpkgs" "neovim" ] );

              buildPlug = name: buildVimPluginFrom2Nix {
                pname = name;
                version = "master";
                src = builtins.getAttr name inputs;
              };
            in
            {
              neovimPlugins = builtins.listToAttrs (map
                (pluginName: {
                  name = pluginName;
                  value = buildPlug pluginName;
                })
                plugins);
            };

        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            pluginOverlay
            (final: prev: {
              neovim-unwrapped = inputs.neovim.packages.${prev.system}.neovim;
            })
          ];
        };
    in rec {

      # Testing something
      nixosModules.default = neovimBuilder {
        inherit pkgs;
        config = {
          customNeovim.colorscheme = "blue";
        };
      };

      packages.${system}.default = neovimBuilder {
        inherit pkgs;
        config = {
          customNeovim.colorscheme = "blue";
        };
        # plugins = builtins.attrValues pkgs.neovimPlugins;
      };

      apps.${system}.default = {
          nvim = {
              type = "app";
              program = "${packages.${system}.default}/bin/nvim";
          };
      };
    };
}
