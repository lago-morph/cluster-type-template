#!/bin/bash

CLUSTER_NAME=$(curl http://169.254.169.254/latest/meta-data/tags/instance/cluster_name)

all_instances=$(aws ec2 describe-instances --filter "Name=tag:cluster_name,Values=$CLUSTER_NAME")

running_instances=$(jq -r '[.Reservations[].Instances[] | select(.State.Name == "running")]' <<< $all_instances)

# puts the data in a Key/Value pair with the Key being the "Name" tag and the
# Value being an object with private_ip, public_ip, and host_class.
nkey=$(jq -r '[.[] |
              (.Tags | from_entries) as $tags |
              {Key: $tags.Name, Value: ({private_ip: .PrivateIpAddress, public_ip: .PublicIpAddress, host_class: $tags.host_class})}]' <<< $running_instances)

# output the data as pairs of lines, host_name, and compact 1-line
# representation of the object with three data lines.
# I then process two lines at a time, passing the json object into jinja2

template=/opt/gitrepo/templates/node.jinja
tempdir=/tmp
destination=/srv/saltclass/nodes
jq -r -c '.[] | .Key, .Value' <<< $nkey |
while read -r host_name; read -r host_data; do
    echo "hostname: $host_name";
    (echo $host_data | jinja2 $template) > $tempdir/$host_name.yml;
    sudo mv $tempdir/$host_name.yml $destination;
done

