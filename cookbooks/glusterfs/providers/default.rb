
# create the yum repo from gluster
# the repo file provide from gluster always installs the latest
# the action will create a repo for a spcific version to install.
action :create_repo do
  version = new_resource.version
  if version!= "LATEST"
      major,minor,min = version.split(".")
  end
  
  log "Creating repo for version #{major}.#{minor}.#{min}"

  template  "/etc/yum.repos.d/gluster.epel.repo" do
    source "repo.erb"
    owner "root"
    group "root"
    mode 0644
    variables({:major=>major,:minor=>minor,:min=>min, :version => version})
    action :create
    notifies :run, "execute[create-yum-cache]", :immediately
    notifies :create, "ruby_block[reload-internal-yum-cache]", :immediately
    
  end
end