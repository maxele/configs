#!/bin/bash

hcbin=/bin/herbstclient
hc() {
    $hcbin "$@"
}

theme() {
  hc attr theme."$@"
}

colors=($(cat ~/.cache/wal/colors))

# bool  tight_decoration = false:   specifies whether the size hints also affect the window decoration or only the window contents of tiled clients (requires enabled sizehints_tiling)

# Default values
theme background_color   ${colors[0]}

theme border_width       2                 # basic border width
theme color              ${colors[1]}            # basic border color
theme inner_color        ${colors[0]}
theme inner_width        0
theme outer_color        ${colors[0]}
theme outer_width        0

theme tab_color          white
theme tab_outer_color    white
theme tab_outer_width    10                # outer border width
theme tab_title_color    white
theme title_when         never
theme title_align        center
theme title_color        white
theme title_depth        0
theme title_font         monospace
theme title_height       20
theme padding_bottom 0 # additional border width on the bottom [uint]
theme padding_left 0 # additional border width on the left [uint]
theme padding_right 0 # additional border width on the right [uint]
theme padding_top 0 # additional border width on the top [uint]

# Default Active
theme active.color              ${colors[8]}
theme active.inner_color        ${colors[0]}
theme active.outer_color        ${colors[0]}

# Default Normal
theme normal.color              ${colors[1]}
theme normal.inner_color        ${colors[0]}
theme normal.outer_color        ${colors[0]}
# Default Urgent
theme urgent.color              #660000
theme urgent.inner_color        ${colors[0]}
theme urgent.outer_color        ${colors[0]}

# Floating
#theme.floating.

# Fullscreen
theme fullscreen.border_width 0
theme fullscreen.color        $green

# Minimal
#theme minimal.

# Tiling
#theme tiling.

