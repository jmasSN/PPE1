#!/usr/bin/bash
#traitement de l'année 2016 on crée on écrase le fichier sortie.txt
echo "Pour l'année 2016 :" > sortie.txt
grep "Location" 2016*.ann | wc -l >> sortie.txt
# Traitement de l'année de l'année 2017
echo "Pour l'année 2017 :" >> sortie.txt
grep "Location" 2017*.ann | wc -l >> sortie.txt
# Traitement de l'année 2018
echo "Pour l'année 2018 :" >> sortie.txt
grep "Location" 2018*.ann | wc -l >> sortie.txt

