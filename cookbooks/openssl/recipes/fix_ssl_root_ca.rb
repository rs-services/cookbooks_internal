if node[:platform] == 'centos' || node[:platform] == 'redhat' 
  remote_file "/etc/pki/tls/certs/ca-bundle.crt" do
    source "http://curl.haxx.se/ca/cacert.pem"
    mode "0644"
    #checksum "08da002l" # A SHA256 (or portion thereof) of the file.
  end
end
