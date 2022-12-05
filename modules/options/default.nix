{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
  cfg = config.vim;
in
{
  # Needs to be the same as cfg
  options.vim = {
      colorscheme = mkOption {
        description = "colorscheme";
        type = types.str;
        default = "desert";
      };
  };

  config = ({
    vim.configRC = ''
      colorscheme ${cfg.colorscheme}
    '';
  });
}
