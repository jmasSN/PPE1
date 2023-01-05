#!/usr/bin/env bash

# Si le nb d'arguments est différent de 2, on arrête l'éxécution du programme
if [[ $# -ne 2 ]]
then
	echo "Deux arguments attendus: <dossier> <langue>"
	exit
fi

#On attribue des noms de variables aux arguments
# Une pour les dumps-text OU les contextes
folder=$1 
# Une pour la langue
basename=$2

#On commence à créer la structure XML dans le fichier de sortie avec une valeur de balise lang égale à basename.
echo "<lang=\"$basename\">" > "./itrameur/$folder-$basename.txt" 

#On viens chercher tous les fichiers qui correspondent à ce qu'on a mis en argument afin de pouvoir les parcourir
for filepath in $(ls $folder/$basename-*.txt) 
do
	pagename=$(basename -s .txt $filepath)
	
    
	#On complète la page XML avec le contenu des fichiers d'aspirations
	echo "<page=\"$pagename\">" >> "./itrameur/$folder-$basename.txt"
	echo "<text>" >> "./itrameur/$folder-$basename.txt"

	
	content=$(cat $filepath)
	# ordre important : & en premier
	# sinon : < => &lt; => &amp;lt;
	
	# On vient nettoyer le corpus de texte des éléments qui pourraient être présents et fausser l'arborescence XML
	content=$(echo "$content" | sed 's/&/\&amp;/g')
	content=$(echo "$content" | sed 's/</\&lt;/g')
	content=$(echo "$content" | sed 's/>/\&gt;/g')

	#On affiche le contenu dans le fichier de sortie
	echo "$content" >> "./itrameur/$folder-$basename.txt"

	# On insère pour chaque page les balises fermantes correspondantes
	echo "</text>" >> "./itrameur/$folder-$basename.txt"
	echo "</page> §" >> "./itrameur/$folder-$basename.txt"
done

# On clôture la structure XML
echo "</lang>" >> "./itrameur/$folder-$basename.txt"

