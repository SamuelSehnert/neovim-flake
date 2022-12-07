{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.gruvbox;
in
{
    options.customNeovim.plugins.gruvbox = {
      enable = mkEnableOption "Enable gruvbox theme";
    };

    config = mkIf cfg.enable {
        customNeovim.startPlugins = with pkgs.neovimPlugins; [gruvbox];
    };
}
