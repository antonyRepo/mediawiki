template '/etc/httpd/conf/httpd.conf' do
    source 'httpd.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
    notifies :run, 'execute[start apache]', :immediately
 end

 execute 'start apache' do
    command "service httpd start"
    owner 'root'
    group 'root'
    action :nothing
 end
