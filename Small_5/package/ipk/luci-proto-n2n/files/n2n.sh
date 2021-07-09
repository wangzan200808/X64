#!/bin/sh

[ -n "$INCLUDE_ONLY" ] || {
	. /lib/functions.sh
	. ../netifd-proto.sh
	init_proto "$@"
}

proto_n2n_setup() {
	local cfg="$1"
	local device="n2n-$cfg"
	local server port server2 port2 community cipher_suite key mode4 ipaddr netmask gateway hostname broadcast defaultroute peerdns dns metric clientid vendorid mode6 ip6addr ip6prefixlen ip6gw reqaddress reqprefix defaultroute6 ip6prefix peerdns6 dns6 clientid6 metric6 mac mtu_n2n reg_interval reg_ttl localport mgmtport forwarding header comp verbose pmtu nop2p multi
	json_get_vars server port server2 port2 community cipher_suite key mode4 ipaddr netmask gateway hostname broadcast defaultroute peerdns dns metric clientid vendorid mode6 ip6addr ip6prefixlen ip6gw reqaddress reqprefix defaultroute6 ip6prefix peerdns6 dns6 clientid6 metric6 mac mtu_n2n reg_interval reg_ttl localport mgmtport forwarding header comp verbose pmtu nop2p multi
	if [ -n "$ipaddr" ];then
		[ -z "$netmask" ] && netmask="255.255.255.0"
		eval $(ipcalc.sh $ipaddr $netmask)
		addr=$ipaddr/$PREFIX
	fi
	proto_run_command "$cfg" /usr/bin/edge -f \
		-d "$device" \
		-l "${server}:${port}" \
		$([ -n "$server2" -a -n "$port2" ] && echo -l "${server2}:${port2}") \
		-c "$community" -$cipher_suite \
		$([ -n "$key" ] && echo -k $key) \
		$([ "$mode4" = dhcp ] && echo -a dhcp:0.0.0.0 || ([ "$mode4" != auto ] && echo -a $addr)) \
		$([ -n "$mac" ] && echo -m $mac) \
		$([ -n "$mtu_n2n" ] && echo -M $mtu_n2n) \
		$([ -n "$reg_interval" ] && echo -i $reg_interval) \
		$([ -n "$reg_ttl" ] && echo -L $reg_ttl) \
		$([ -n "$localport" ] && echo -p $localport) \
		$([ -n "$mgmtport" ] && echo -t $mgmtport) \
		$([ "$forwarding" = 0 ] || echo -r) \
		$([ "$header" = 0 ] || echo -H) \
		$([ "$comp" = 1 ] && echo -z1) \
		$([ "$verbose" = 1 ] && echo -v) \
		$([ "$pmtu" = 1 ] && echo -D) \
		$([ "$nop2p" = 1 ] && echo -S) \
		$([ "$multi" = 1 ] && echo -E)

	proto_init_update "$device" 1 1
	proto_set_keep 1
	sleep 1
	local A=0
	if [ "$mode4" = static ];then
		while [ -z "$(ifconfig "$device" | grep inet | grep -v inet6 | awk '{print $2}' | sed 's/addr://g')" ];do
			sleep 1
		done
		proto_add_ipv4_address "$ipaddr" "$netmask"
		[ -n "$gateway" ] && proto_add_ipv4_route 0.0.0.0 0 "$gateway" "" "$metric"
		for dns in $dns; do
			proto_add_dns_server "$dns"
		done
	fi
	if [ "$mode4" = auto ];then
		while :;do
			a=$(ifconfig "$device" | grep inet | grep -v inet6 | awk '{print $2}' | sed 's/addr://g')
			[ -n "$a" ] && break
			sleep 1
		done
		proto_add_ipv4_address "$a" "$(ifconfig "$device" | grep inet | grep -v inet6 | awk '{print $4}' | sed 's/Mask://g')"
	fi
	if [ "$mode6" = static ];then
		ifconfig "$device" "${ip6addr}/${ip6prefixlen}"
		proto_add_ipv6_address "$ip6addr" "$ip6prefixlen"
		[ -n "$ip6gw" ] && proto_add_ipv6_route "::" 0 "$ip6gw" "$metric6"
		proto_send_update "$cfg" && A=1
	fi
	if [ "$mode4" = dhcp ];then
		[ $A = 0 ] && proto_send_update "$cfg" && A=1
		ZONE=$(fw3 -q network $cfg 2>/dev/null) && local A=1
		json_init
		json_add_string name "${cfg}_DHCP"
		json_add_string ifname "@$cfg"
		json_add_string proto "dhcp"
		[ -n "$hostname" ] && json_add_string hostname "$hostname"
		[ -n "$broadcast" ] && json_add_boolean broadcast "$broadcast"
		[ "$defaultroute" = 1 ] || json_add_boolean defaultroute 0
		[ "$peerdns" = 1 ] || json_add_boolean peerdns 0
		[ -n "$dns" ] && json_add_array dns "$dns"
		[ -n "$metric" ] && json_add_int metric "$metric"
		[ -n "$clientid" ] && json_add_string clientid "$clientid"
		[ -n "$vendorid" ] && json_add_string vendorid "$vendorid"
		[ -n "$ZONE" ] && json_add_string zone "$ZONE"
		json_close_object
		ubus call network add_dynamic "$(json_dump)"
	fi
	if [ "$mode6" = dhcp ];then
		[ $A = 0 ] && proto_send_update "$cfg" && A=1
		json_init
		json_add_string name "${cfg}_DHCPv6"
		json_add_string ifname "@$cfg"
		json_add_string proto "dhcpv6"
		[ -n "$reqaddress" ] && json_add_string reqaddress "$reqaddress"
		[ -n "$reqprefix" ] && json_add_string reqprefix "$reqprefix"
		[ "$defaultroute6" = 1 ] || json_add_boolean defaultroute 0
		[ -n "$ip6prefix" ] && json_add_array ip6prefix "$ip6prefix"
		[ "$peerdns6" = 1 ] || json_add_boolean peerdns 0
		[ -n "$dns6" ] && json_add_array dns "$dns6"
		[ -n "$clientid6" ] && json_add_string clientid "$clientid6"
		[ -n "$ZONE" ] && json_add_string zone "$ZONE"
		json_close_object
		ubus call network add_dynamic "$(json_dump)"
	fi
	[ $A = 0 ] && proto_send_update "$cfg"
}

proto_n2n_teardown() {
	local cfg="$1"
	local device="n2n-$cfg"
	proto_init_update "$device" 0
	proto_kill_command "$1"
	kill -9 `ps -w|grep edge|grep ${device}|awk '{print $1}'` >/dev/null 2>&1
	proto_send_update "$cfg"
}

proto_n2n_init_config() {
	no_device=1
	available=1
	proto_config_add_string "server"
	proto_config_add_int "port"
	proto_config_add_string "server2"
	proto_config_add_int "port2"
	proto_config_add_string "community"
	proto_config_add_string "cipher_suite"
	proto_config_add_string "key"
	proto_config_add_string "mode4"
	proto_config_add_string "ipaddr"
	proto_config_add_string "netmask"
	proto_config_add_string "gateway"
	proto_config_add_string "hostname"
	proto_config_add_boolean "broadcast"
	proto_config_add_boolean "defaultroute"
	proto_config_add_boolean "peerdns"
	proto_config_add_string "dns"
	proto_config_add_int "metric"
	proto_config_add_string "clientid"
	proto_config_add_string "vendorid"
	proto_config_add_string "mode6"
	proto_config_add_string "ip6addr"
	proto_config_add_int "ip6prefixlen"
	proto_config_add_string "ip6gw"
	proto_config_add_string "reqaddress"
	proto_config_add_string "reqprefix"
	proto_config_add_boolean "defaultroute6"
	proto_config_add_array 'ip6prefix'
	proto_config_add_boolean "peerdns6"
	proto_config_add_string "dns6"
	proto_config_add_string "clientid6"
	proto_config_add_int "metric6"
	proto_config_add_string "mac"
	proto_config_add_int "mtu_n2n"
	proto_config_add_string "reg_interval"
	proto_config_add_string "reg_ttl"
	proto_config_add_int "localport"
	proto_config_add_int "mgmtport"
	proto_config_add_boolean "forwarding"
	proto_config_add_boolean "header"
	proto_config_add_boolean "comp"
	proto_config_add_boolean "verbose"
	proto_config_add_boolean "pmtu"
	proto_config_add_boolean "nop2p"
	proto_config_add_boolean "multi"
}

[ -n "$INCLUDE_ONLY" ] || {
	add_protocol n2n
}
