# Adds the LocalSettings.php 
# Updates the httpd.conf with correct DocumentRoot and DirectoryIndex
# Starts Apache server

template '/var/www/mediawiki/LocalSettings.php' do
    source 'LocalSettings.php.erb'
    mode '0757'
    owner 'root'
    group 'root'
  end

template '/etc/httpd/conf/httpd.conf' do
    source 'httpd.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
    notifies :run, 'execute[start apache]', :immediately
 end

 execute 'start apache' do
    command "service httpd start"
    action :nothing
 end
