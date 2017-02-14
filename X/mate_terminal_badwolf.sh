#!/bin/bash

(
cat <<EOF
[profiles/default]
background-color='#141414141313'
foreground-color='#F8F8F6F6F2F2'
palette='#1C1C1B1B1A1A:#FFFF2C2C4B4B:#AEAEEEEE0000:#FAFADEDE3E3E:#0A0A9D9DFFFF:#FFFF9E9EB8B8:#8C8CFFFFBABA:#FFFFFFFFFFFF:#1C1C1B1B1A1A:#FFFF2C2C4B4B:#AEAEEEEE0000:#FAFADEDE3E3E:#0A0A9D9DFFFF:#FFFF9E9EB8B8:#8C8CFFFFBABA:#FFFFFFFFFFFF'
use-system-font=true
use-theme-colors=false
visible-name='Default (Badwolf)'

[global]
default-profile='default'
EOF
) | dconf load /org/mate/terminal/
