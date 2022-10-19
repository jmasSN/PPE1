N=0
while read LINE
do
	N=$(expr $N + 1)
	echo "$N je lis : $LINE"
done
echo "Fin"
