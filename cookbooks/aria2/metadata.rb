maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures aria2"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "aria2::default", "installs aria2"
recipe "aria2::download_file", "downloads a specific file via aria2"

attribute "aria2/download_file",
  :display_name => "File to Download via aria2", 
  :description => "File to Download via aria2",
  :recipes => [ "aria2::download_file" ],
  :required => "required"

attribute "aria2/download_dir",
  :display_name => "Directory to download file to",
  :description => "Directory to download file to",
  :recipes => [ "aria2::download_file" ],
  :required => "required"

