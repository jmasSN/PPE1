#!/usr/bin/env bash

#===============================================================================
# Ce script est notre programme pour traiter les URLs. Il permet de créer un tableau HTML en sortie avec chaque URL, le code de réponse correspondant .
# Il s'utilise dans le dossier avec le fichier à traiter <URL.txt> (avec un URL/ligne) avec la ligne de commande :
# bash traitement_url_base.sh <URL.txt>  <tableauURL.html> 

#<tableauURL.html>  est le fichier de sortie du tableau HTML (ici il n'existe pas avant le lancement du script).
#Il est nécéssaire d'avoir créer des dossiers 'dumps-text' et 'aspirations' dans le dossier d'utilisation du script.
#===============================================================================

# On vérifie que l'on a 2 arguments :
if [ $# -ne 2 ]
then
	echo " ce programme demande deux arguments"
	exit
fi

# On vérifie que le fichier d'URLs existe :
if [ -f $1 ]
	then
		echo "Fichier OK"
	else
		echo "Ceci n'est pas un fichier valide."
		exit
fi


# On attribue les fichiers en argument à des variables :
fichier_urls=$1 # le fichier d'URL en entrée
fichier_tableau=$2 # le fichier HTML en sortie




echo $fichier_urls;
basename=$(basename -s .txt $fichier_urls)

# On crée l'architecture HTML du tableau de sortie dans le fichier donné en second argument :
echo "<html><head><meta charset="UTF-8" /><link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css"/>" > $fichier_tableau
echo "<body>" > $fichier_tableau
echo "<h2>Tableau $basename :</h2>" >> $fichier_tableau
echo "<br/>" >> $fichier_tableau
echo "<table>" >> $fichier_tableau
echo "<tr><th>ligne</th><th>code</th><th>URL</th><th>encodage</th></tr>" >> $fichier_tableau

# On crée un compteur pour les URLs/le nombre de lignes :               
lineno=1;
# On lit chaque ligne :
while read -r line;
do
# On récupère l'URL (=la ligne)
    URL=$line
	# On récupère le code réponse
    CODEHTTP=$(curl -I -s $line | grep -e "^HTTP/" | grep -Eo "[0-9]{3}" | head -n1)	
	# On récupère l'encodage
	ENC=$(curl -I -s $line | grep -Eo "charset=[\w-]+"| cut -d= -f2)
	# On récupère le contenu de la page HTML
	aspiration=$(curl $URL)
	# On met chaque aspirations dans un fichier nouveau fichier HTML
	echo "$aspiration" > "aspirations/$basename-$lineno.html"

	# On affiche les informations dans le terminal
	#echo -e "\tURL : $URL";
	echo -e "\tURL N°: $lineno";
    echo -e "\tcode : $CODEHTTP";
	
	if [[ ! $ENC ]]
	then
		echo -e "\tEncodage non détecté, on prendra UTF-8 par défaut.";
		ENC="UTF-8";
	else
		echo -e "\tEncodage : $ENC";
	fi
	# Si le code der éponse est différent de 200
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
