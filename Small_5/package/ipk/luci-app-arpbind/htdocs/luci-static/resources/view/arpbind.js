'use strict';
'require form';
'require rpc';
'require view';
'require tools.widgets as widgets';

return view.extend({
	callHostHints: rpc.declare({
		object: 'luci-rpc',
		method: 'getHostHints',
		expect: { '': {} }
	}),

	load: function(){
		return this.callHostHints();
	},

	render: function (stats){
		var m,s,o;

		m=new form.Map("arpbind",_("IP/MAC Binding"),_("ARP is used to convert a network address (e.g. an IPv4 address) to a physical address such as a MAC address,You can add some static ARP binding rules here"));

		s=m.section(form.TableSection,"arpbind",_("Rules"));
		s.anonymous=true;
		s.addremove=true;

		o=s.option(form.Value,"ipaddr",_("IP Address"));
		o.datatype="ipaddr";
		o.optional=false;
		L.sortedKeys(stats,'ipv4','addr').forEach(function(mac){
			o.value(stats[mac].ipv4,'%s (%s)'.format(
				stats[mac].ipv4,
				stats[mac].name || mac
			));
		});

		o=s.option(form.Value,"macaddr",_("MAC Address"));
		o.datatype="macaddr";
		o.optional=false;
		L.sortedKeys(stats,'ipv4','addr').forEach(function(mac){
			o.value(mac,'%s (%s)'.format(
				mac,
				stats[mac].ipv4
			));
		});

		o=s.option(widgets.DeviceSelect,"ifname",_("Interface"));
		o.rmempty=false;
		o.noaliases=true;
		o.noinactive=true;
		o.default="br-lan";

		return m.render()
	}
})
