#!/bin/bash
cat package.json |
sed -n '/scripts/,/}/p' |
tail -n +2 |
sed '$d'|
grep -E '"[a-z]' |
sed 's/^[[:space:]]*//g'|
sed 's/^"//g' | sed 's/":/ ➖/g' |
awk '{print $1}' |
sed 's/^/🔘️ /g' |
fzf --info=inline --prompt="🔮 " |
#  --header="
# <CR> to run, <S-CR> to select
# " |
# awk '{print $1}' |
# sed 's/"://g' |
# sed 's/^"//g' |
sed 's/^🔘️ //g' |
xargs -I _ npm run _
