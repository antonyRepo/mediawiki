packages_to_install = node['media_wiki']['package_list'] 
wiki_version = '/tmp/release.json'

packages_to_install.each do |pckg|
    package pckg do
        action :install
    end
end

ruby_block 'get_release_version' do
    block do
        data = JSON.parse(IO.read(wiki_version))
        node.force_default['media_wiki']['media_wiki_version'] = data['wiki_version']
    end

    only_if { File.exist?(wiki_version)}
    action :run
    notifies :run, 'bash[download_app]', :immediate
end

ruby_block "get_public_hostname" do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
        command = 'cat /tmp/hostname'
        command_out = shell_out(command)
        node.force_default['media_wiki']['public_hostname']  = command_out.stdout
    end
    action :create
    notifies :create, 'template[/var/www/mediawiki/LocalSettings.php]', :immediate
end

template '/var/www/mediawiki/LocalSettings.php' do
    source 'LocalSettings.php.erb'
    mode '0750'
    owner 'root'
    group 'root'
    variables(wgserver: node['media_wiki']['public_hostname'])
  end
