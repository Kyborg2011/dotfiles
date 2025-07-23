{ inputs, ... } :

{
  imports = [
    inputs.hyprshell.homeModules.hyprshell
  ];
  
  programs.hyprshell = {
    enable = true;
    systemd.args = "-v";
    settings = {
      windows = {
        overview = {
          key = "super_l";
          launcher = {
            max_items = 6;
            plugins = {
              calc = {
                enable = true;
              };
              websearch = {
                enable = false;
              };
            };
          };
        };
        switch = {
          enable = false;
          modifier = "alt";
          show_workspaces = false;
        };
      };
    };
  };
}