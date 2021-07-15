local fs=require "nixio.fs"

function string.split(input,delimiter)
	input=tostring(input)
	delimiter=tostring(delimiter)
	if (delimiter=='') then return false end
	local pos,arr=0,{}
	for st,sp in function() return string.find(input,delimiter,pos,true) end do
		table.insert(arr,string.sub(input,pos,st-1))
		pos=sp+1
	end
	table.insert(arr,string.sub(input,pos))
	return arr
end

m=Map("cpufreq",translate("CPU Freq Settings"))
m.description=translate("Set CPU Scaling Governor to Max Performance or Balance Mode")

s=m:section(NamedSection,"cpufreq","settings")
s.anonymouse=true

a=luci.sys.exec("echo -n $(find /sys/devices/system/cpu/cpufreq/policy* -maxdepth 0 | grep -Eo [0-9]+)")
for _,b in ipairs(string.split(a," ")) do
	if not fs.access("/sys/devices/system/cpu/cpufreq/policy"..b.."/scaling_available_frequencies") then return end

	cpu_freqs=fs.readfile("/sys/devices/system/cpu/cpufreq/policy"..b.."/scaling_available_frequencies")
	cpu_freqs=string.sub(cpu_freqs,1,-3)

	cpu_governors=fs.readfile("/sys/devices/system/cpu/cpufreq/policy"..b.."/scaling_available_governors")
	cpu_governors=string.sub(cpu_governors,1,-3)

	freq_array=string.split(cpu_freqs," ")
	governor_array=string.split(cpu_governors," ")

	s:tab(b,translate("Policy "..b))

	o=s:taboption(b,ListValue,"mode"..b,translate("CPU Scaling Governor"))
	for _,e in ipairs(governor_array) do
		if e ~= "" then o:value(e,translate(e)) end
	end

	o=s:taboption(b,ListValue,"min"..b,translate("Min Idle CPU Freq"))
	for _,e in ipairs(freq_array) do
		if e ~= "" then o:value(e) end
	end

	o=s:taboption(b,ListValue,"max"..b,translate("Max Turbo Boost CPU Freq"))
	for _,e in ipairs(freq_array) do
		if e ~= "" then o:value(e) end
	end

	o=s:taboption(b,Value,"rate"..b,translate("CPU Switching Sampling rate"))
	o.datatype="range(1,100000)"
	o.description=translate("The sampling rate determines how frequently the governor checks to tune the CPU (ms)")
	o.placeholder=10
	o:depends("mode"..b,"ondemand")

	o=s:taboption(b,Value,"up"..b,translate("CPU Switching Threshold"))
	o.datatype="range(1,99)"
	o.description=translate("Kernel make a decision on whether it should increase the frequency (%)")
	o.placeholder=50
	o:depends("mode"..b,"ondemand")
end

return m
