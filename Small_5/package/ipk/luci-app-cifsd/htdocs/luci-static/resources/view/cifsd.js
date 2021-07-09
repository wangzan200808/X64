'use strict';
'require fs';
'require form';
'require view';

return view.extend({
	load: function(){
		return Promise.all([
			L.resolveDefault(fs.stat('/sbin/block'),null),
			L.resolveDefault(fs.stat('/etc/config/fstab'),null),
		]);
	},
	render: function (stats){
		var m,s,o;

		m=new form.Map("ksmbd",_("Network Shares"));

		s=m.section(form.TypedSection,"globals",_("CIFSD is an opensource In-kernel SMB1/2/3 server"));
		s.anonymous=true;

		s.tab("general",_("General Settings"));
		s.tab("template",_("Edit Template"));

		s.taboption("general",form.Value,"description",_("Description"));

		o=s.taboption("general",form.Value,"workgroup",_("Workgroup"));
		o.placeholder='WORKGROUP';

		o=s.taboption("template",form.TextValue,"tmp","",
		_("This is the content of the file '/etc/ksmbd/smb.conf.template' from which your cifsd configuration will be generated. \
		Values enclosed by pipe symbols ('|') should not be changed. They get their values from the 'General Settings' tab."));
		o.rows=20;
		o.cfgvalue=function (section_id){
			return fs.trimmed('/etc/ksmbd/smb.conf.template');
		};
		o.write=function (section_id,formvalue){
			return fs.write('/etc/ksmbd/smb.conf.template',formvalue.trim().replace(/\r\n/g,'\n')+'\n');
		};

		s=m.section(form.TableSection,"share",_("Shared Directories"));
		s.anonymous=true;
		s.addremove=true;

		s.option(form.Value,"name",_("Name"));

		o=s.option(form.Value,"path",_("Path"));
		if (stats[0] && stats[1]){
			o.titleref=L.url("admin","system","mounts");
		}

		o=s.option(form.Flag,"browseable",_("Browseable"));
		o.rmempty=false;
		o.enabled="yes";
		o.disabled="no";
		o.default="yes";

		o=s.option(form.Flag,"read_only",_("Read-only"));
		o.rmempty=false;
		o.enabled="yes";
		o.disabled="no";

		o=s.option(form.Flag,"guest_ok",_("Allow Guest"));
		o.rmempty=false;
		o.enabled="yes";
		o.disabled="no";
		o.default="yes";

		o=s.option(form.Value,"create_mask",_("Files Mask"),_("Mask for new files"));
		o.rmempty=true;
		o.size=4;
		o.default="0644";

		o=s.option(form.Value,"dir_mask",_("Directory Mask"),_("Mask for new directories"));
		o.rmempty=true;
		o.size=4;
		o.default="0755";

		return m.render()
	}
})
