root_path = node['media_wiki']['root_path']
media_wiki_version = node['media_wiki']['media_wiki_version'] 

bash 'download_app' do
    cwd root_path
    code <<-EOH
      wget https://releases.wikimedia.org/mediawiki/1.34/mediawiki-#{media_wiki_version}.tar.gz
      tar -zxf mediawiki-#{media_wiki_version}.tar.gz
      ln -s mediawiki-#{media_wiki_version}/ mediawiki
      rm -rf mediawiki-#{media_wiki_version}.tar.gz
    EOH
    action :nothing
end

template '/etc/httpd/conf/httpd.conf' do
   source 'httpd.conf.erb'
   owner 'root'
   group 'root'
   mode '0755'
end

