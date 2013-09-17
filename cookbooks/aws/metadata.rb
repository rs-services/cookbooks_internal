name             'aws'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures aws'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.5'

depends "rightscale"
depends "python"

recipe "aws::do_install_ses", "configures aws for amazon" 
recipe "aws::do_install_awscli", "installs aws cli"

attribute "aws/ses/username", 
  :display_name => "SES Username",
  :description => "SES Username",
  :required => "required",
  :recipes => [ "aws::do_install_ses" ]

attribute "aws/ses/password",
  :display_name => "SES password",
  :description => "SES password",
  :required => "required",
  :recipes => [ "aws::do_install_ses" ]

attribute "aws/ses/domain",
  :display_name => "SES domain",
  :description => "SES domain",
  :required => "required",
  :recipes => [ "aws::do_install_ses" ]

attribute "aws/aws_access_key_id",
  :display_name => "AWS Access Key ID",
  :description => "AWS Access Key ID",
  :required => "required",
  :recipes => [ "aws::do_install_awscli" ]

attribute "aws/aws_secret_access_key",
  :display_name => "AWS Secret Access Key",
  :description => "AWS Secret Access Key",
  :required => "required",
  :recipes => [ "aws::do_install_awscli" ]

attribute "aws/region",
  :display_name => "AWS Region",
  :description => "AWS Region",
  :required => "required",
  :recipes => [ "aws::do_install_awscli" ]

