{
	ORS=","
	print $1
	print $2
	for (i = 3; i <= NF; i++){
		if (i == NF)
			ORS=""

		if ($2 ~ /HIB/)
			print ($i / $3 - 1) * 100
		else
			print ($3 / $i - 1) * 100
	}
	printf "\n"
}
