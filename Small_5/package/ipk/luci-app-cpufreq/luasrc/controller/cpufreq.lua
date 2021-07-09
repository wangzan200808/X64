module("luci.controller.cpufreq",package.seeall)
function index()
	if not nixio.fs.access("/etc/config/cpufreq") then
		return
	end
	local e=entry({"admin","services","cpufreq"},cbi("cpufreq"),_("CPU Freq"),90)
	e.dependent=false
	e.acl_depends={"luci-app-cpufreq"}
end
