{ pkgs, config, ... }:
{
    imports = [
        ./core
        ./options
        ./keymap
        ./plugins
        ./themes
    ];
}
