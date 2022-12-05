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

  vim = vimOptions.config.vim;
in
pkgs.wrapNeovim pkgs.neovim-unwrapped {
  viAlias = true;
  vimAlias = true;
  configure = {

    customRC = vim.configRC;

    packages.myVimPackage = with pkgs.neovimPlugins; {
      # start = plugins;
      start = [];
      opt = [];
    };
  };
}
