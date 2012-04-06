cookbook_file "/etc/yum.repos.d/s3cmd.repo" do
  source "s3tools.repo"
end

package "s3cmd" do 
  action :install
end

