// write config file

$temporary_directory = New-TemporaryFile 
New-Item "$CONF_DIR\config.json" -Value @"
{
	"datacenter" : "dc1",
		"data_dir" : $temporary_directory.FullName,
		"node_name" : <%= p('consul.machine_name') %>,
		"server" : false,
		"ports" : 53,
		"domain" : "cf.internal",
		"bind_addr" : <%= p('consul.machine_ip') %>,
		"rejoin_after_leave" : true,
		"disable_remote_exec" : true,
		"disable_update_check" : true,
		"protocol" : 2,
		"verify_outgoing" : <%= p('consul.enable_ssl') %>,
		"verify_incoming" : <%= p('consul.enable_ssl') %>,
		"verify_server_hostname" : <%= p('consul.enable_ssl') %>,
		"ca_file" : <%= p('consul.ca_file') %>,
		"key_file" : <%= p('consul.key_file') %>,
		"cert_file" : <%= p('consul.cert_file') %>,
		"start_join" : <%= p('consul.consul_ips') %>,
		"retry_join" : <%= p('consul.consul_ips') %>
}

"@

