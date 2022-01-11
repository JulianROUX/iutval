#!/bin/bash

# Script de controle pour le TP2
clear

echo "ATTENTION  le nom de l'archive sera basé sur celui de cette VM !"
echo "Le nom actuel de cette VM est $HOSTNAME"
echo "Elle doit impérativement être à ton NOM !"
echo ""
echo "le paquet ftp doit être installé pour le transfert de l'archive"
echo ""
echo "Tape Entrée pour continuer ou CTRL-C pour sortir"
read x

echo "Là, normalement, tu as moyennement confiance dans ce qu'il va se passeer :-)"
echo ""
sleep 3

if [ ! -f /usr/bin/ftp ]
then
	echo "le paquet ftp n'est pas installé"
	echo "installe le paquet ftp et exécute à nouveau le script"
	exit
fi

if [ ! -d /tmp/$HOSTNAME-tp3 ]
then
	mkdir /tmp/$HOSTNAME-tp3
	fi

cd /tmp/$HOSTNAME-tp3

cat /etc/machine-id >./idmac
history >./hist
tar -czf ./etc.tar /etc
lsblk >./lsblk.out
ls -l /var >./var.content 2>&1
ls -l /etc >./etc.content 2>&1
ls -l /svg >./svg.content 2>&1
tar -czf ./logs.tar /var/log

if [ -f /tmp/optimrun ]
	then
		cp /tmp/optimrun ./optimrun
	else
		echo "optimrun absent" >./optimrun
fi

ls -l /etc/grub.d/* >./grub.d.content 2>&1
grep "pbkdf2" /etc/grub.d/* >./grub.ident 2>&1
fichident=$(grep "pbkdf2" /etc/grub.d/* | cut -d':' -f1)

if [ -z "$fichident" ]
	then
		echo "pas de fichier d'identification" >./fichident
	else
		cp $fichident ./fich.ident
fi

cp /boot/grub/grub.cfg ./grub.cfg

cd /tmp
tar -czf $HOSTNAME-tp3.tar /tmp/$HOSTNAME-tp3

echo " "
echo "Maintenant, on envoie tout ça à la Sainte Inquisition pour vérifier si tu as commis des hérésies"
sleep 2

# Connexion ftp toujours aussi sale avec un mot de passe en clair
# de toute façon cet utilisateur ftp est enfermé (chrooté) dans
# une arborescence, le risque est donc limité
cd /tmp
ftp -n <<CESTPASFAUX
open ftp.oximae.net
user oximae-lpasur "lemotdepasseQuelM0T2P4SS3"
cd TP3
lcd /tmp
put "$HOSTNAME-tp3.tar"
close
bye
CESTPASFAUX
# Qu'est-ce que c'est que vous n'avez pas compris dans CESTPASFAUX ?

echo
echo "Normalement, tout s'est bien passé"
echo "Demande quand-meme confirmation, on sait jamais"
echo
echo "PS : Cette fois, rien n'a été supprimé, promis ;-)"
echo
