file="package.json"
if [ ! -e "$file" ]; then
    echo "No $file file 🫥"
	exit 1
fi


cat package.json |
sed -n '/scripts/,/}/p' |
tail -n +2 |
sed '$d'|
grep -E '"[a-z]' |
sed 's/^[[:space:]]*//g'|
sed 's/^"//g' | sed 's/":/ ➖/g' |
awk '{print $1}' |
fzf --no-info --pointer=🚀 --prompt="🔥 " --header="Type, vim or arrow keys then <Enter>" |
xargs -I _ npm run _
