{ pkgs, customRC ? "" , plugins ? [], ... }:
let
  # myNeovimUnwrapped = pkgs.neovim-unwrapped.overrideAttrs (prev: {
  #   propagatedBuildInputs = with pkgs; [ pkgs.stdenv.cc.cc.lib ];
  # });

  # vimOptions = lib.evalModules {
  #   modules = [
  #     { imports = [../modules]; }
  #     config 
  #   ];
  #
  #   specialArgs = {
  #     inherit pkgs; 
  #   };
  # };
in
pkgs.wrapNeovim pkgs.neovim-unwrapped {
  viAlias = true;
  vimAlias = true;
  configure = {
    customRC = customRC;
    # This is base neovim configuration
    packages.myVimPackage = with pkgs.neovimPlugins; {
      start = plugins;
      opt = [];
    };
  };
}
