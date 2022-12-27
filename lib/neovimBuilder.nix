{ pkgs, config, ... }:
let
    lib = pkgs.lib;

    vimOptions = lib.evalModules {
        modules = [
            { imports = [../modules]; }
            config 
        ];

        specialArgs = {
            inherit pkgs; 
        };
      
    };

    customNeovim = vimOptions.config.customNeovim;
in
    pkgs.wrapNeovim pkgs.neovim-unwrapped {
        viAlias = customNeovim.viAlias;
        vimAlias = customNeovim.vimAlias;
        configure = {
            customRC = customNeovim.configRC;

            packages.myVimPackage = {
              start = builtins.filter (f: f != null) customNeovim.startupPlugins;
              opt = builtins.filter (f: f != null) customNeovim.optionalPlugins;
            };
        };
    }
