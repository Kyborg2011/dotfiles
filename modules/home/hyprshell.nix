{ inputs, ... } :

{
  programs.hyprshell = {
    enable = true;
    systemd.args = "-v";
    settings = {
      windows = {
        overview = {
          key = "super_l";
          mod = super;
          launcher = {
            max_items = 10;
            plugins.websearch = {
              enable = true;
              engines = [{
                name = "DuckDuckGo";
                url = "https://duckduckgo.com/?q=%s";
                key = "d";
              }];
            };
          };
        };
        switcher.enable = false;
      };
    };
  };
}