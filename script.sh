#!/bin/bash

hosts () {
read -p "Select Hosts : " hosts
}
while true
do
until [ ! -z $hosts ]
do
hosts
done
echo " 1. Change Host or Inventory"
echo " 2. Check OS Details"
echo " 3. User Management"
echo " 4. Execute ad-hoc commands for practice"
echo " 5. Install packages using yum (Make sure destination server is configured with repo)"
echo " 6. Copy File from source to destination"
echo " 10. exit"
read -p " Select Number : " Input
case $Input in
1)
hosts
;;
2)
sed -i "s/- hosts.*/- hosts: ${hosts}/g" healthcheckup.yml
ansible-playbook healthcheckup.yml
;;
3)
read -p "Enter Username : " Username
read -p "Enter Password : " Passwd
sed -i "s/- hosts.*/- hosts: ${hosts}/g" user.yml
sed -i "7s/name.*/name: ${Username}/g" user.yml
password="password: \"{{ '$Passwd' | password_hash('sha512') }}\""
sed -i "s/password.*/${password}/g" user.yml
ansible-playbook user.yml
ansible -m shell -a "id $Username" $hosts
;;
4)
ansible_command=''
read -p "Enter ansible ad-hoc command : ansible " ansible_command
ansible $ansible_command 
[ $? = 0 ] && echo "Command execute successfully" || echo " Please check syntax first"
;;
5)
sed -i "s/- hosts.*/- hosts: ${hosts}/g" yum.yml
read -p "Enter Package Name : " package
sed -i "7s/name.*/name: ${package}/g" yum.yml
sed -i "12s/name.*/name: ${package}/g" yum.yml
ansible-playbook yum.yml
;;
6)
src=""
dest=""
read -p "Enter source file path : " src
read -p "Enter destination path : " dest
sed -i "s/- hosts.*/- hosts: ${hosts}/g" copy.yml
sed -i "7s|src.*|src: ${src}|g" copy.yml
sed -i "8s|dest.*|dest: ${dest}|g" copy.yml
ansible-playbook copy.yml
;;
10)
exit
;;
*)
;;
esac
done
