module("luci.controller.filetransfer",package.seeall)
function index()
	local e=entry({"admin","system","filetransfer"},cbi("updownload"),_("FileTransfer"),1)
	e.dependent=false
	e.acl_depends={"luci-mod-system-config"}
end
