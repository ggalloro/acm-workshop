#!/bin/bash
# This version of the script works only with GNU sed
# If using a mac, please run setup.sh
echo "ACM Workshop user accounts set up"
echo
echo "This verison of the setup script works only on Linux machines"
echo "If using Mac please run setup.sh"
echo
echo "Enter 1st user name:"
read user1
sed -i "s/user1/$user1/g" assets/namespaces/application1/user1_bind.yaml
echo "Enter 2nd user name:"
read user2
sed -i "s/user2/$user2/g" assets/namespaces/application2/user2_bind.yaml
