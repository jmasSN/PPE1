#!/usr/bin/env bash

#===============================================================================
# VOUS DEVEZ MODIFIER CE BLOC DE COMMENTAIRES.
# Ici, on décrit le comportement du programme.
# Indiquez, entre autres, comment on lance le programme et quels sont
if [ $# -ne 2 ]
then
	echo " ce programme demande deux arguments"
	exit
fi
# les paramètres.
# La forme est indicative, sentez-vous libres d'en changer !
# Notamment pour quelque chose de plus léger, il n'y a pas de norme en bash.
#===============================================================================

fichier_urls=$1 # le fichier d'URL en entrée
fichier_tableau=$2 # le fichier HTML en sortie
# !!!!!!
# ici on doit vérifier que nos deux paramètres existent, sinon on ferme!
# !!!!!!

# modifier la ligne suivante pour créer effectivement du HTML

palabra="étranger" # on peut faire mieux ez
echo $fichier_urls;
basename=$(basename -s .txt $fichier_urls)
   
echo "<html><body>" > $fichier_tableau
echo "<h2>Tableau $basename :</h2>" >> $fichier_tableau
echo "<br/>" >> $fichier_tableau
echo "<table>" >> $fichier_tableau
echo "<tr><th>ligne</th><th>code</th><th>URL</th><th>encodage</th></tr>" >> $fichier_tableau

lineno=1;
                while read -r line;
do
        URL=$line
        CODEHTTP=$(curl -I -s $line | grep -e "^HTTP/" | grep -Eo "[0-9]{3}" | head -n1)	
        ENC=$(curl -I -s $line | grep -Po "charset=[\w-]+"| cut -d= -f2)
		aspiration=$(curl $URL)
	echo "$aspiration" > "aspirations/$basename-$lineno.html"

	#echo -e "\tURL : $URL";
	echo -e "\tURL N°: $lineno";
    echo -e "\tcode : $CODEHTTP";

	if [[ ! $ENC ]]
	then
		echo -e "\tencodage non détecté, on prendra UTF-8 par défaut.";
		ENC="UTF-8";
	else
		echo -e "\tencodage : $ENC";
	fi

	if [[ $CODEHTTP -eq 200 ]]                                                                                                                                         
	then
		dump=$(lynx -dump -nolist -assume_charset=$ENC -display_charset=$ENC $URL)
		echo "$dump" > "dumps-text/$basename-$lineno.txt" 
		if [[ $ENC -ne "UTF-8" && -n "$dump" ]]
		then
			dump=$(echo $dump | iconv -f $ENC -t UTF-8//IGNORE)
		fi
	else
		echo -e "\tcode différent de 200 utilisation d'un dump vide"
		dump=""
		ENC=""
	fi
    
    echo "<tr><td>$lineno</td><td>$CODEHTTP</td><td>$URL</td><td>$ENC</td></tr>" >> $fichier_tableau
	lineno=$((lineno+1));
                
       done < $fichier_urls               

        echo "</table></body></html>" >> $fichier_tableau
