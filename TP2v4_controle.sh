#!/bin/bash

# Script de controle pour le TP2
clear

echo "ATTENTION  le nom de l'archive sera basé sur celui de cette VM !"
echo "Elle doit impérativement être à ton NOM ! (/etc/hostname)"
echo ""
echo "Tape Entrée pour continuer ou CTRL-C pour sortir"
read x

if [ -z /usr/bin/ftp ]
then
	echo "Le paquet ftp n'est pas installé"
	echo "Il est nécessaire pour l'envoi du rapport"
	echo "installe le avec 'apt install ftp'"
	echo
	exit
fi

echo "On rassemble les infos utiles pour voir si tu as bien bossé :-)"
echo ""

if [ ! -d /tmp/$HOSTNAME-tp2 ]
then
	mkdir /tmp/$HOSTNAME-tp2
	fi

if [ -f /tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt ]
then
	rm /tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
	fi

cat /etc/machine-id >/tmp/$HOSTNAME-tp2/machine-id.txt

cd /tmp/$HOSTNAME-tp2

echo " --- Étape 1.1 -----" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
blkid >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
df -h >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo " --- Étape 1.2 -----" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo "show databases;" >/tmp/show.sql
mysql -t </tmp/show.sql >>/tmp/$HOSTNAME-tp2/db-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
cat /tmp/$HOSTNAME-tp2/db-TP2.txt >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo "use mysql;" >/tmp/users.sql
echo "select user,host from user" >>/tmp/users.sql
mysql -t </tmp/users.sql >>/tmp/$HOSTNAME-tp2/users-TP2.txt
cat /tmp/$HOSTNAME-tp2/users-TP2.txt >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo " --- Étape 1.3 -----" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
ls -la /var/cloud/* >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo " --- Étape 2 -----" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
pvs >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
vgs >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
lvdisplay >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo " --- Étape 3 -----" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
df >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
blkid >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
cat /etc/fstab >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo " --- Étape 4 -----" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo "----- /dev" >>/tmp/$HOSTNAME-tp2/DossierDEV-TP2.txt
ls -R /dev/* >>/tmp/$HOSTNAME-tp2/DossierDEV-TP2.txt
echo " "

echo "----- /etc/fstab" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
cat /etc/fstab >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo "----- lsblk" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
lsblk >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo "----- pvs" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
pvs >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " ">>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo "----- lvdisplay" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
lvdisplay >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo "----- fdisk" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
fdisk -l /dev/vgcloud/lvcloud >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo "------ /var/cloud" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
ls -Rla /var/cloud/ >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

echo "------ cloud occ" >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
if test -f /var/www/html/occ
	then
		sudo -u www-data php /var/www/html/occ status >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
	elif test -f $(find /var/www -name occ -print)
		then
			sudo -u www-data php $(find /var/www -name occ -print) status >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
		else
			echo "commande occ non trouvée" echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt
fi
echo " " >>/tmp/$HOSTNAME-tp2/$HOSTNAME-TP2.txt

history >>/tmp/$HOSTNAME-tp2/hist

cd /tmp
tar -czf $HOSTNAME-tp2.tar /tmp/$HOSTNAME-tp2

echo " "
echo "Maintenant, on envoie tout ça au FSB (pour changer)"
sleep 2

# Connexion ftp toujours aussi sale avec un mot de passe en clair
# de toute façon cet utilisateur ftp est enfermé (chrooté) dans
# une arborescence, le risque est donc limité
cd /tmp
ftp -n <<CONCOMBRE
open ftp.oximae.net
user oximae-lpasur "lemotdepasseQuelM0T2P4SS3"
cd TP2
lcd /tmp
put "$HOSTNAME-tp2.tar"
close
bye
CONCOMBRE
# CONCOMBRE, pourquoi concombre ? Une sorte de suite logique...

echo
echo "Normalement, tout s'est bien passé"
echo "Demande quand-meme confirmation, on sait jamais"
