#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2025 osipog

# Get all tabs, including their ids and focused status
tab_info=$(kitty @ ls | jq -r '[
    .[].tabs[]
    | (.windows | first) as $window
    | ($window | .foreground_processes | first | .cmdline | first | split("/") | last) as $program
    | {
        title: ([
            $program,
            .title,
            ($window | .last_reported_cmdline),
            ($window | .cwd)
        ] | join(" | ")),
        id,
        is_focused,
        lines: $window | .lines,
        first_window_id: $window | .id,
    }
]
    | sort_by(.title)
    | reverse
    | sort_by(.is_focused)
    | reverse
')

# Generate preview files that can be used by fzf
echo "$tab_info" | jq -c '.[]' | while read -r item; do
    filename="/tmp/kitty-tab-switcher-preview-tab-id-$(echo "$item" | jq -r '.id')"
    kitty @ launch \
        --source-window="id:$(echo "$item" | jq -r '.first_window_id')" \
        --stdin-source=@screen \
        --stdin-add-formatting \
        --type=background \
        tee "$filename"\
        > /dev/null
done

tab_count=$(echo "$tab_info" | jq 'length')
line_height=$(echo "$tab_info" | jq 'first | .lines')
# prompt (1) + divider (1) + list-border (2)
list_line_height=$((tab_count + 1 + 1 + 2))
preview_percent_height=$(( ( (line_height - list_line_height) * 100 ) / line_height ))

# Use fzf to fuzzy search the tab titles
# shellcheck disable=SC2016
selected=$(echo "$tab_info" \
    | jq -r ' .[] | (.id | tostring) + " | " + .title' \
    | fzf \
        --height=100% \
        --margin=0 \
        --padding=0 \
        --border=none \
        --list-border=rounded \
        --info=hidden \
        --layout=reverse \
        --cycle \
        --preview-window=down,"$preview_percent_height"%,+"$((list_line_height + 2))",noinfo,border-none,nofollow,nocycle \
        --preview='cat /tmp/kitty-tab-switcher-preview-tab-id-$(echo {} | awk "{print \$1}")')

# If a tab was selected, focus on that tab using its ID
if [ -n "$selected" ]; then
    tab_id=$(echo "$selected" | awk '{print $1}')
    kitty @ focus-tab --match id:"$tab_id"
else
    echo "No tab selected or operation cancelled."
fi
