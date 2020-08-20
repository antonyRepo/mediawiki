template '/etc/httpd/conf/httpd.conf' do
    source 'httpd.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
 end