date=`date +%Y-%m-%d`

echo -n "Long title:"
read title
echo -n "Tags:"
read tags



vi `awk -f _template.awk -v title="$title" -v tags="$tags" -v date="$date" _template.md`

# cp _template.md $date-$title.md
