{ config, lib, pkgs, ...}:

with lib;
with builtins;

let
  cfg = config.customNeovim;
in {
  options.customNeovim = {
    # viAlias = mkOption {
    #   description = "Enable vi alias";
    #   type = types.bool;
    #   default = true;
    # };
    #
    # vimAlias = mkOption {
    #   description = "Enable vim alias";
    #   type = types.bool;
    #   default = true; 
    # };

    configRC = mkOption {
      description = ''vimrc contents'';
      type = types.lines;
      default = "";
    };
  };

  config = {
  };

}
