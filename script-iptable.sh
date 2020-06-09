#!/bin/bash

echo -e "--------Script IPTABLES--------"

############################# Programa de Firewall y reglas############################### 
buildfirewall()
 {
  ###############Obteniendo la cadena############
  echo -e "Seleccione un tipo de cadena\n
  1. INPUT
  2. OUTPUT
  3. FORWARD
  4. PREROUTING
  5. POSTROUTING"
  read opt_ch
  case $opt_ch in
   1) chain="INPUT" ;;
   2) chain="OUTPUT" ;;
   3) chain="FORWARD" ;;
   4) chain="PREROUTING" ;;
   5) chain="POSTROUTING";;
   *) echo -e "Opción inválida"
  esac
 
  #########Obteniendo direccion IP fuente##########
 
   
  echo -e "
  1. Regla usando direccion IP de origen única\n
  2. Regla usando direccion subred de origen\n
  3. Regla usando todas las redes de origen\n"
  read opt_ip
 
  case $opt_ip in
   1) echo -e "\nIntroduzca la IP origen"
   read ip_source ;;
   2) echo -e "\nIntroduzca la IP de la subred de origen (Por ejemplo 192.168.10.0/24)"
   read ip_source ;;
   3) ip_source="0/0" ;;
   #4) ip_source = "NULL" ;;
   *) echo -e "Opción errónea"
  esac
  #########Obteniendo la direccion IP destino##########
   echo -e "
  1. Regla usando direccion IP destino única\n
  2. Regla usando direccion de subred destino\n
  3. Regla usando todas las redes de destino\n"
  
     read opt_ip
              case $opt_ip in
        1) echo -e "\nIntroduzca la IP origen"
                     read ip_dest ;;
        2) echo -e "\nIntroduzca la IP de la subred destino(Por ejemplo 192.168.10.0/24)"
                     read ip_dest ;;
        3) ip_dest="0/0" ;;
        #4) ip_dest = "NULL" ;;
        *) echo -e "Opcion errónea"
       esac



       ###############Obteniendo el Protocolo#############
       echo -e "
       1. Aplicado a todo el tráfico TCP
       2. Aplicado a todo el trafico UDP
       3. Aplicado a un puerto espécifico TCP
       4. Aplicado a un puerto especifico UDP 
       5. Sin protocolo"
       read proto_ch
	puerto="NULL"
       case $proto_ch in
        1) proto=TCP ;;
        2) proto=UDP ;;
        3) echo -e "Ingresar el numero de puerto TCP:"
           proto=TCP
           read puerto ;;
        4) echo -e "Ingresar el numero de puerto UDP:"
	   proto=UDP
	   read puerto;;
	5) proto="NULL"
	   puerto="NULL";;
        *) echo -e "Opcion errónea"
       esac
 
       #############Accion con la regla############# 
       echo -e "¿Qué acción realizar con la regla?
       1. Aceptar el paquete
       2. Rechazar el paquete
       3. Dropear el paquete
       4. Crear Log"
       read rule_ch
       case $rule_ch in 
        1) rule="ACCEPT" ;;
        2) rule="REJECT" ;;
        3) rule="DROP" ;;
        4) rule="LOG" ;;
       esac
###################Generando la regla####################
echo -e "\n\tPresione cualquier letra para generar la regla:"
read temp
echo -e "La regla generada es: \n"

echo -e "$proto yyyyy $puerto \n"
if [ $proto == "NULL" ] && [ $puerto == "NULL" ]; then
 echo -e "\niptables -A $chain -s $ip_source -d $ip_dest -j $rule\n"
 gen=1
else
  if [ $proto != "NULL" ] && [ $puerto == "NULL" ]; then	
     echo -e "\niptables -A $chain -s $ip_source -d $ip_dest -p $proto -j $rule\n"
     gen=2
  else
    echo -e "\niptables -A $chain -s $ip_source -d $ip_dest -p $proto --dport $puerto -j $rule\n"
    gen=3
fi
 
fi 
echo -e "\n\tDesea ingresar la regla anterior a IPTABLES? Si=1 , No=2"
read yesno

if [ $yesno == 1 ]; then
  if [ $gen == 1 ]; then
     iptables -A $chain -s $ip_source -d $ip_dest -j $rule
     echo -e "Se agregó la regla iptables -A $chain -s $ip_source -d $ip_dest -j $rule \n" >> /etc/iptables/bitacora.log
  else
	if [ $gen == 2 ]; then
	  iptables -A $chain -s $ip_source -d $ip_dest -p $proto -j $rule
	  echo -e "Se agregó la regla  iptables -A $chain -s $ip_source -d $ip_dest -p $proto -j $rule\n" >> /etc/iptables/bitacora.log
	else
	  iptables -A $chain -s $ip_source -d $ip_dest -p $proto --dport $puerto -j $rule
	  echo -e "Se agregó la regla  iptables -A $chain -s $ip_source -d $ip_dest -p $proto --dport $puerto -j $rule\n" >> /etc/iptables/bitacora.log
       fi
  fi
else
  proto="NULL"
  puerto="NULL"
  main
fi
}

quitar_reglas()
{  
   echo -e "Seleccione un tipo de cadena a eliminar\n
  1. INPUT
  2. OUTPUT
  3. FORWARD
  4. PREROUTING
  5. POSTROUTING
  6. TODAS LAS CADENAS"
  read opt_ch
  case $opt_ch in
   1) chain="INPUT" ;;
   2) chain="OUTPUT" ;;
   3) chain="FORWARD" ;;
   4) chain="PREROUTING" ;;
   5) chain="POSTROUTING";;
   6) chain="";;
   *) echo -e "Opción inválida"
  esac
  iptables -F $chain
  if [ $chain != "" ]; then
 	 echo "Se eliminaron las reglas de la cadena $chain \n" >> /etc/iptables/bitacora.log 
  else 
	echo "Se eliminaron las reglas de todas las cadenas (flush)" >> /etc/iptables/bitacora.log
}

      
main()
{
 ROOT_UID=0
 if [ $UID == $ROOT_UID ];
 then
 clear
 opt_main=1
 while [ $opt_main != 4 ]
 do

#############Menu principal############ 
 echo -e "\t---------Menú Principal---------\n
 
 1. Agregar una regla al firewall
 2. Quitar reglas
 3. Salir"
 read opt_main
 case $opt_main in
  1) buildfirewall ;;
  2) quitar_reglas ;;
  3) exit 0 ;;
  *) echo -e "Opcion incorrecta"
 esac
done
else
 echo -e "Debes ser root para ejecutar este script"
fi
}
main
exit 0


