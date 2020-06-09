
# /var/lib/dhcp/dhcpd.leases
#!/bin/bash
function f_mac_to_ip {

parseResult=$(cat /var/lib/dhcp/dhcpd.leases |  egrep -o 'lease.*{|ethernet.*;' | awk '{print $2}' | xargs -n 2 | cut -d ';' -f 1  | grep $1 | awk '{print $1}')
    echo "$parseResult"
}

f_mac_to_ip
