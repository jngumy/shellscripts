awk 'BEGIN{
    while( (getline line < "maclist") > 0){
        mac[line]
    }
    RS="}"
    FS="\n"
}
/lease/{
    for(i=1;i<=NF;i++){
        gsub(";","",$i)
        if ($i ~ /lease/) {
            m=split($i, IP," ")
            ip=IP[2]
        }
        if( $i ~ /hardware/ ){
            m=split($i, hw," ")
            ether=hw[3]
        }
        if ( $i ~ /client-hostname/){
            m=split($i,ch, " ")
            hostname=ch[2]
        }
        if ( $i ~ /uid/){
            m=split($i,ui, " ")
            uid=ui[2]
        }
    }
    if ( ether in mac ){
        print "ip: "ip " hostname: "hostname " ether: "ether " uid: "uid
    }
} ' /var/lib/dhcp/dhcpd.leases
