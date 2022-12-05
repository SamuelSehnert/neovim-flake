# { pkgs, config, customRC ? "" , plugins ? [], ... }:
{ pkgs, config, ... }:
let
  lib = pkgs.lib;

  vimOptions = lib.evalModules {
    modules = [
      { imports = [./modules]; }
      config 
    ];

    specialArgs = {
      inherit pkgs; 
    };
    
  };

  customNeovim = vimOptions.config.customNeovim;
in
pkgs.wrapNeovim pkgs.neovim-unwrapped {
  viAlias = true;
  vimAlias = true;
  configure = {

    customRC = customNeovim.configRC;

    packages.myVimPackage = with pkgs.neovimPlugins; {
      # start = plugins;
      start = [];
      opt = [];
    };
  };
}
