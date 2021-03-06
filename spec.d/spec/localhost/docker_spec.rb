require 'spec_helper'

describe 'It should have docker installed' do
	describe package 'lxc-docker-1.3.0' do
		it { should be_installed }
	end

	describe group 'docker' do
		it { should exist }
	end

	describe file '/var/run/docker.sock' do
		it { should be_socket }
		it { should be_owned_by 'root' }
		it { should be_grouped_into 'docker' }
	end

	describe command 'docker -v' do
		its(:stdout) { should match '^Docker version 1\.3.*' }
 	end
end

describe 'vagrant user should be able to use docker' do
	describe group 'docker' do
		it { should exist }
	end

	describe user 'vagrant' do
		it { should belong_to_group 'docker' }
	end
end


describe 'Docker should be running' do
	describe service 'docker' do
		it { should be_running }
	end

	describe process 'docker' do
		it { should be_running }
		its(:args) { should match /\/var\/run\/docker\.sock/ }
	end
end

describe 'Docker should have networking set up' do
	describe interface 'docker0' do
		it { should have_ipv4_address("172.17.42.1/16") }
	end

	describe iptables, :sudo => true do
		  it { should have_rule('-P POSTROUTING ACCEPT').
	 		with_table('nat').
			with_chain('POSTROUTING')
		  }
		  it { should have_rule('-A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE').
	 		with_table('nat').
			with_chain('POSTROUTING')
		  }
	end

end

describe 'Docker settings should be correct' do
	describe command 'docker info' do
		its(:stdout) { should match /^Storage Driver.*devicemapper/ }
		its(:stdout) { should match /^Execution Driver.*native/ }
	end
end

describe 'Workshop image(s) should be present' do
	describe command 'docker images' do
		its(:stdout) { should match /ubuntu.*14.04/ }
		its(:stdout) { should match /busybox/ }
		its(:stdout) { should match /registry/ }
	end
end
