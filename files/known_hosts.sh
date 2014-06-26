#!/bin/bash
array=( 'gitlab.innogames.de' )
for h in "${array[@]}"
do
    #echo $h
    ip=$(dig +short $h)
    ssh-keygen -R $h
    ssh-keygen -R $ip
    ssh-keyscan -H $ip >> /home/vagrant/.ssh/known_hosts
    ssh-keyscan -H $h >> /home/vagrant/.ssh/known_hosts
done
