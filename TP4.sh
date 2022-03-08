#!/bin/bash

# Script de controle pour le TP4
clear

echo "On prend quelques photos souvenir, ça ne sera pas long"
echo ""

# Création du dossier d'archive
if [ ! -d /root/TP4 ]
	then
		mkdir /root/TP4
fi
arch=/root/TP4

# Contrôles sur VM1
cat /etc/machine-id >>$arch/00-VM1id

#Partie 1
systemctl status networking >>$arch/01-VM1net 2>&1
cat /etc/network/interfaces >>$arch/02-VM1int
ip a >>$arch/03-VM1ip

if [ -f /$arch/03-VM2pin ]
	then
		rm $arch/03-VM2pin
fi

ping -c5 192.168.0.10 >>/$arch/03-VM2pin 2>&1
if [ $? -ne 0 ]
	then
		echo "la VM2 n'est pas joignable" >/$arch/03-VM2pin
	fi

#Partie 2
systemctl status isc-dhcp-server >>$arch/04-VM1isc 2>&1
grep -A 10 "INTERFACE" /etc/default/isc-dhcp-server >>$arch/05-VM1def 2>&1
cat /etc/resolv.conf >>$arch/06-VM1res

#Partie 3
grep "net.ipv4" /etc/sysctl.conf >>$arch/07-VM1ro1
cat /proc/sys/net/ipv4/ip_forward >>$arch/08-VM1ro2
cat /etc/nftables.conf >>$arch/09-VM1nft
systemctl status nftables >>$arch/10-VM1nft 2>&1

#Partie 4
dpkg -l | grep nmap >>$arch/11-VM1nma

#Partie 5
systemctl status apache2 >>$arch/13-VM1apa 2>&1
ls -l /etc/apache2/mods-enabled/prox* >>$arch/14-VM1mod 2>&1

#Génération du script de controle VM2

cat <<EOF >/$arch/TP4VM2.sh
#!/usr/bin/bash
clear
if [ ! -d /root/TP4-VM2 ]
	then
		mkdir /root/TP4-VM2
fi
arch=/root/TP4-VM2
cat /etc/machine-id >>\$arch/00-VM2id
#Partie 1
systemctl status NetworkManager >>\$arch/01-VM2net 2>&1
cat /etc/sysconfig/network-scripts/ifcfg* >>\$arch/02-VM2int 2>&1
ip a >>\$arch/03-VM2ip

#Partie 2
cat /etc/resolv.conf >>\$arch/06-VM2res

#Partie 3
ip route show >>\$arch/07-VM2rou

#Partie 4
yum list installed | grep wget >>\$arch/11-VM2wge 2>&1
yum list installed | grep vsftpd >>\$arch/12-VM2vsf 2>&1

#Partie 5
systemctl status httpd >>\$arch/13-VM2apa 2>&1

#Fin d'exécution
echo "Le script de contrôle est terminé"
echo "Les fichiers de contrôle sont dans le dossier \$arch"
echo "Il faut maintenant les transférer sur VM1"
echo "dans le dossier /root/TP4/"
EOF

chmod +x $arch/TP4VM2.sh


echo
echo "Le script est terminé"
echo "Les éléments de cette VM sont dans /root/TP4/"
echo "le script TP4VM2.sh a également été créé dans ce dossier"
echo ""
echo "il faut maintenant le transférer sur VM2,"
echo "L'exécuter, et transfrérer les fichiers de contrôle sur VM1"
echo "dans le dossier $arch"
echo ""
echo "Lorsque les fichiers des 2 VM sont dans le dossier $arch,"
echo "crée une archive TAR de ce dossier et dépose le sur Moodle"
