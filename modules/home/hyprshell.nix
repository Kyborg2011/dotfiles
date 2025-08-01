{ inputs, ... } :

{
  imports = [
    inputs.hyprshell.homeModules.hyprshell
  ];
  
  programs.hyprshell = {
    enable = true;

    systemd = {
      enable = true;
      args = "-v";
    };

    settings = {
      windows = {
        overview = {
          enable = true;
          key = "super_l";
          launcher = {
            enable = true;
            max_items = 6;
            plugins = {
              calc = {
                enable = true;
              };
              websearch = {
                enable = false;
              };
              applications.show_actions_submenu = true;
            };
          };
        };
        switch = {
          enable = true;
          modifier = "alt";
          show_workspaces = true;
        };
      };
    };
  };
}