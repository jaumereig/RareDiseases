# Convert all xlsx to csv

group="pakistan_bcn_tu";
dir="/home/vant/Escritorio/pid/${group}/AY*/ShortVariants";

for file in ${dir}; do
	for element in $file/*.xlsx; do
		echo $element;
		xlsx2csv -d 'tab' $element $element.tsv;
		echo "**************************";
		echo "**************************";
		echo "**************************";
	done;
done;
