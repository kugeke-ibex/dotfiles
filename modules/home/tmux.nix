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
      set -g status-position top

      # Splits keep current path
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Pane navigation (vim-style)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane resize (大文字 hjkl, prefix を保持して連打可)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Window navigation
      bind Tab last-window

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "tmux config reloaded"

      # Copy mode (vi-like, macOS pbcopy 連携)
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi Y send-keys -X copy-pipe-and-cancel "pbcopy"
    '';
  };
}
