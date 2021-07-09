local fs=require "nixio.fs"

cpu_freqs=fs.readfile("/sys/devices/system/cpu/cpufreq/policy0/scaling_available_frequencies")
cpu_freqs=string.sub(cpu_freqs,1,-3)

cpu_governors=fs.readfile("/sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors")
cpu_governors=string.sub(cpu_governors,1,-3)

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

freq_array=string.split(cpu_freqs," ")
governor_array=string.split(cpu_governors," ")

m=Map("cpufreq",translate("CPU Freq Settings"))
m.description=translate("Set CPU Scaling Governor to Max Performance or Balance Mode")

s=m:section(NamedSection,"cpufreq","settings")
s.anonymouse=true

o=s:option(ListValue,"mode",translate("CPU Scaling Governor"))
for _,e in ipairs(governor_array) do
	if e ~= "" then o:value(e,translate(e)) end
end

o=s:option(ListValue,"min",translate("Min Idle CPU Freq"))
for _,e in ipairs(freq_array) do
	if e ~= "" then o:value(e) end
end

o=s:option(ListValue,"max",translate("Max Turbo Boost CPU Freq"))
for _,e in ipairs(freq_array) do
	if e ~= "" then o:value(e) end
end

o=s:option(Value,"up",translate("CPU Switching Threshold"))
o.datatype="range(1,99)"
o.description=translate("Kernel make a decision on whether it should increase the frequency (%)")
o.placeholder=50
o:depends("mode","ondemand")

o=s:option(Value,"rate",translate("CPU Switching Sampling rate"))
o.datatype="range(1,100000)"
o.description=translate("The sampling rate determines how frequently the governor checks to tune the CPU (ms)")
o.placeholder=10
o:depends("mode","ondemand")

return m
