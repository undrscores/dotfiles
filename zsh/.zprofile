[ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = /dev/tty1 ] && exec uwc-session


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
