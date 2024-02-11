{
	ORS=","
	print $1
	print $2
	for (i = 3; i <= NF; i++){
		if (i == NF)
			ORS=""

		if ($2 ~ /HIB/) {
			if (length($4) != 0 && length($i) != 0)
				print ($i / $4 - 1) * 100
			else
				print "N/A"
		} else {
			if (length($4) != 0 && length($i) != 0)
				print ($4 / $i - 1) * 100
			else
				print "N/A"
		}
	}
	printf "\n"
}
