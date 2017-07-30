#!/usr/bin/env ruby

require 'rubydns'
require 'rubydns/system'
 
INTERFACES = [
	[:udp, "0.0.0.0", 5300],
	[:tcp, "0.0.0.0", 5300]
]

Name = Resolv::DNS::Name
IN = Resolv::DNS::Resource::IN

UPSTREAM = RubyDNS::Resolver.new([[:udp, "8.8.8.8", 53], [:tcp, "8.8.8.8", 53]])
	
RubyDNS::run_server(INTERFACES) do
	# How to respond to something other than what was requested.
	match(//, IN::A) do |transaction|
		transaction.respond!(Name.create('foo.bar'), resource_class: IN::CNAME)
	end

	otherwise do |transaction|
		transaction.passthrough!(UPSTREAM)
	end
end
