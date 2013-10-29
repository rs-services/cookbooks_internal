name             'smartfox'
maintainer        'Rightscale Professional Services' 
maintainer_email  "ps@rightscale.com"
license          'All rights reserved'
description      'Installs/Configures smartfox'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"

recipe "smartfox::install"                , "Installs Smartfox"
recipe "smartfox::install_license_server" , "Installs Smartfox license server"

attribute "smartfox/license_server",
	:description => "DNS address of Smartfox License Server",
	:recipes     => ["smartfox::install"],
	:type        => "string",
	:display     => "smartfox/license_server",
	:required    => "required"

attribute "smartfox/license_number",
	:description => "License slot number",
	:recipes     => ["smartfox::install"],
	:type        => "string",
	:display     => "smartfox/license_server",
	:required    => "required"

attribute "smartfox/storage_account_id",
  :description => "API public key of storage provider (s3, cloudfiles, ...)",
  :recipes     => ["smartfox::install", "smartfox::install_license_server"],
  :type        => "string",
  :display     => "smartfox/storage_account_id",
  :required    => "required"

attribute "smartfox/storage_account_secret",
  :description => "API private key of storage provider (s3, cloudfiles, ...)",
  :recipes     => ["smartfox::install", "smartfox::install_license_server"],
  :type        => "string",
  :display     => "smartfox/storage_account_secret",
  :required    => "required"

attribute "smartfox/bucket",
  :description => "Bucket name where Smartfox is stored",
  :recipes     => ["smartfox::install", "smartfox::install_license_server"],
  :type        => "string",
  :display     => "smartfox/bucket",
  :required    => "required"

attribute "smartfox/file",
  :description => "Path to file in container",
  :recipes     => ["smartfox::install", "smartfox::install_license_server"],
  :type        => "string",
  :display     => "smartfox/bucket",
  :required    => "required"

attribute "smartfox/provider",
  :description => "Storage account provider (s3, cloudfiles, ...)",
  :recipes     => ["smartfox::install", "smartfox::install_license_server"],
  :type        => "string",
  :display     => "smartfox/provider",
  :required    => "required"

attribute "smartfox/tier",
  :description => "Smartfox tier of this host",
  :recipes     => ["smartfox::install"],
  :type        => "string",
  :display     => "smartfox/tier",
  :required    => "required",
  :choice      => ["5inarow", "anagrammagic", "boxo", "discpool", "bullfrogpoker", "dogfight"]

attribute "smartfox/hostname",
  :description => "DNS name of this host",
  :recipes     => ["smartfox::install"],
  :type        => "string",
  :display     => "smartfox/hostname",
  :required    => "required"

attribute "smartfox/bullfrog_poker_db_host",
  :description => "DNS name Bullfrog Poker database host",
  :recipes     => ["smartfox::install"],
  :type        => "string",
  :display     => "smartfox/bullfrog_poker_db_host",
  :required    => "required"

attribute "smartfox/bullfrog_poker_username",
  :description => "Bullfrog poker database username",
  :recipes     => ["smartfox::install"],
  :type        => "string",
  :display     => "smartfox/bullfrog_poker_username",
  :required    => "required"

attribute "smartfox/bullfrog_poker_password",
  :description => "Bullfrog poker database password",
  :recipes     => ["smartfox::install"],
  :type        => "string",
  :display     => "smartfox/bullfrog_poker_password",
  :required    => "required"

attribute "smartfox/serpent_endpoint",
  :description => "Serpent API endpoint hostname",
  :recipes     => ["smartfox::install"],
  :type        => "string",
  :display     => "smartfox/serpent_endpoint",
  :required    => "required"

attribute "smartfox/discpool_load_balancer_dns_name",
  :description => "DNS name of the loadbalancer used by Discpool",
  :recipes     => ["smartfox::install"],
  :type        => "string",
  :display     => "smartfox/discpool_load_balancer_dns_name",
  :required    => "optional"
