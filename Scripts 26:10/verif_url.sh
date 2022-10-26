#!/usr/bin/bash
if [ $# -ne 1] # Si le nb d'argument est différent de 1 alors : (avec ne = not equal)
then
	echo "Ce programme demande un fichier en argument."
		exit
	fi
	
	if [ -f $1 ] # Si l'argument est un fichier qui existe alors :
	then
		echo "Fichier OK"
	else
		echo "Ceci n'est pas un fichier"
		exit
	FICHIER_URLS=$1
	OK=0
	NOK=0
	while read -r LINE ; # -r => ignore les échappements qui ne sont pas encodés (genre \n)
	do
		echo "La ligne : $LINE"
		if [[ $LINE =~ "https?://"]]
		then
			echo "ressemble à une URL valide"
			OK=$(expr $OK + 1)
		else
			echo "ne ressemble pas à une URL valide."
			NOK=$(expr $NOK + 1)
		fi
	done <	FICHIER_URLS
	echo "$OK URLs et $NOK lignes douteuses."