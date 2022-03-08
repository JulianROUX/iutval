#!/usr/bin/bash
clear
if [ ! -d /root/TP4-VM2 ]
	then
		mkdir /root/TP4-VM2
fi
arch=/root/TP4-VM2
cat /etc/machine-id >>$arch/00-VM2id
#Partie 1
systemctl status NetworkManager >>$arch/01-VM2net 2>&1
cat /etc/sysconfig/network-scripts/ifcfg* >>$arch/02-VM2int 2>&1
ip a >>$arch/03-VM2ip

#Partie 2
cat /etc/resolv.conf >>$arch/06-VM2res

#Partie 3
ip route show >>$arch/07-VM2rou

#Partie 4
yum list installed | grep wget >>$arch/11-VM2wge 2>&1
yum list installed | grep vsftpd >>$arch/12-VM2vsf 2>&1

#Partie 5
systemctl status httpd >>$arch/13-VM2apa 2>&1

#Fin d'exécution
echo "Le script de contrôle est terminé"
echo "Les fichiers de contrôle sont dans le dossier $arch"
echo "Il faut maintenant les transférer sur VM1"
echo "dans le dossier /root/TP4/"
