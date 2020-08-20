# Downloads and installs all dependent packages
# Reads the media wiki code version to be donwloaded and installed

packages_to_install = node['media_wiki']['package_list'] 
wiki_version = '/tmp/release.json'

include_recipe 'media_wiki::download_app'

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
