#!/bin/bash
# Launch Ghostty with 4 pre-configured tabs (name + color).
# Requires macOS accessibility permission for osascript.

tabs=(
  "home|#5588ff"
  "code|#55bb55"
  "vibe|#ff5555"
  "cluster|#ffbb33"
)

new_tab() {
  osascript -e '
    tell application "System Events" to tell process "Ghostty"
      keystroke "t" using command down
    end tell
  '
}

setup_tab() {
  local name="$1" color="$2"
  osascript -e "
    tell application \"System Events\" to tell process \"Ghostty\"
      keystroke \"printf '\\\\033]0;${name}\\\\007' && printf '\\\\033]30;${color}\\\\007'\"
      keystroke return
    end tell
  "
}

# Launch Ghostty and wait for it to be ready
open -a Ghostty
sleep 1
osascript -e 'tell application "Ghostty" to activate'
sleep 0.5

# Configure the first tab (already open)
IFS='|' read -r name color <<< "${tabs[0]}"
setup_tab "$name" "$color"

# Open and configure remaining tabs
for i in 1 2 3; do
  sleep 0.3
  new_tab
  sleep 0.5
  IFS='|' read -r name color <<< "${tabs[$i]}"
  setup_tab "$name" "$color"
done

# Return to first tab
sleep 0.3
osascript -e '
  tell application "System Events" to tell process "Ghostty"
    keystroke "1" using command down
  end tell
'
