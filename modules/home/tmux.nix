{ ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    historyLimit = 50000;
    terminal = "screen-256color";
    shortcut = "a";
    escapeTime = 0;

    extraConfig = ''
      set -g renumber-windows on
      set -g focus-events on
      set -g status-interval 5

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind r source-file ~/.config/tmux/tmux.conf \; display "tmux config reloaded"
    '';
  };
}
