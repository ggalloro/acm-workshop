#!/bin/bash
echo "ACM Workshop user accounts set up"
echo
echo "Enter 1st user name:"
read user1
sed -i.bak "s/user1/$user1/g" assets/namespaces/application1/rolebinding_user1.yaml
echo "Enter 2nd user name:"
read user2
sed -i.bak "s/user2/$user2/g" assets/namespaces/application2/rolebinding_user2.yaml
rm -rf assets/namespaces/application1/rolebinding_user1.yaml.bak
rm -rf assets/namespaces/application2/rolebinding_user2.yaml.bak