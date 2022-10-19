N=0
for ELEMENT in $(ls)
do
	if [[ $ELEMENT =~ ^test ]]
	then
		echo "Voici le contenu de $ELEMENT"
		cat $ELEMENT
	fi
done
