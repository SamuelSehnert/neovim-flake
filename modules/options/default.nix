{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
  cfg = config.customNeovim;
in
{
  # Needs to be the same as cfg
  options.customNeovim = {
      colorscheme = mkOption {
        description = "colorscheme";
        type = types.str;
        default = "desert";
      };
  };

  config = ({
    customNeovim.configRC = ''
      colorscheme ${cfg.colorscheme}
    '';
  });
}
