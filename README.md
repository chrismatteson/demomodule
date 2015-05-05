# demomodule

This module collects several small single or only a couple manifests demos which I have to keep from having a million modules that I manage.  As of when I'm updating this those are:

cisco.pp - This sets up puppet device to manage an aws csr1000v.  The AWS AMI needs to be created by hand, a user added to it, and device.conf updated on the proxy system.

nagios_* - Apply nagios_target.pp to the clients and nagios_server to the nagios server.  They each reference common themselves.  The server can, and probably should, also be a client.

rspec_puppet.pp - This adds the gems and the .fixtures.yml to run 'rake spec' against ntp and apache.  I thinks this might blow up your master, so be careful, I need to test more.

user.pp - This is my basic demo class.  It adds a user, group, and updates a file.  It can be applied against both linux and windows.

webblog.pp - This installs mysql/apache/wordpress and shoehorns in my blog.
