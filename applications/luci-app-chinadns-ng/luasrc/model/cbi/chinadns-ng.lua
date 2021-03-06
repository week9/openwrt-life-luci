-- Copyright (C) 2020 KGHX <openwrt.ikghx.com>
-- Licensed to the public under the GNU General Public License v3.
local state = (luci.sys.call("pidof chinadns-ng > /dev/null") == 0)

if state then
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

m = Map("chinadns-ng", translate("ChinaDNS-ng") .. state_msg)

s = m:section(TypedSection, "chinadns-ng", translate("General Settings"))
s.anonymous = true

o = s:option(Flag, "enable", translate("Enable"))
o.rmempty = false

o = s:option(Value, "bind_addr", translate("Listen Address"))
o.datatype    = "ipaddr"
o.rmempty     = false

o = s:option(Value, "bind_port", translate("Listen Port"))
o.datatype    = "port"
o.rmempty     = false

o = s:option(Value, "china_dns", translate("China DNS"))
o.placeholder = "127.0.0.1#5356"
o.rmempty     = false

o = s:option(Value, "trust_dns", translate("Trust DNS"))
o.placeholder = "127.0.0.1#5354"
o.rmempty     = false

o = s:option(Flag, "reuse_port", translate("Enable multi-process"),
	translate("Simultaneously start multiple chinadns-ng processes for load balancing."))
o.rmempty     = false

o = s:option(Flag, "chnlist_first", translate("Priority match chnlist"),
	translate("Priority matching China website list, default priority matching gfwlist"))
o.rmempty     = false

o = s:option(Flag, "fair-mode", translate("Fair model"),
	translate("If a trusted DNS response is returned first, this option should be enabled."))
o.rmempty     = false

o = s:option(Flag, "noip_as_chnip", translate("Accept response without IP"),
	translate("Accept reply with qtype of A/AAAA but no IP"))
o.rmempty     = false

o = s:option(Value, "ipset_name4", translate("The name of the China IPv4 ipset collection"))
o.placeholder = "chnroute"
o.rmempty     = false

o = s:option(Value, "ipset_name6", translate("The name of the China IPv6 ipset collection"))
o.placeholder = "chnroute6"
o.rmempty     = false

o = s:option(Value, "gfwlist_file", translate("Blacklist domain name file"),
	translate("The domain names in this file only use trusted DNS queries."))
o.placeholder = "/etc/chinadns-ng/gfwlist.txt"
o.datatype    = "file"
o.rmempty     = false

o = s:option(Value, "chnlist_file", translate("Whitelist domain name files"),
	translate("The domain names in this file only use china DNS queries."))
o.placeholder = "/etc/chinadns-ng/chnlist.txt"
o.datatype    = "file"
o.rmempty     = false

o = s:option(Value, "timeout_sec", translate("Upstream DNS timeout (seconds)"))
o.placeholder = "5"
o.rmempty     = false

o = s:option(Value, "repeat_times", translate("Number of DNS queries"),
	translate("Send several query packets to the trusted DNS each time, default is 1."))
o.placeholder = "1"
o.rmempty     = false

local apply = luci.http.formvalue("cbi.apply")
if apply then
	luci.util.exec("/etc/init.d/chinadns-ng restart >/dev/null 2>&1")
end

return m
