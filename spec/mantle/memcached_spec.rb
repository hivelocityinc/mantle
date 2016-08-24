require 'spec_helper'

describe package('memcached') do
  it { should be_installed }
end

describe file('/var/run/memcached') do
  it { should be_directory }
end

describe process("memcached") do
  it { should be_running }
end

describe command('memcached -V') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /memcached 1\.4\..+/ }
end

describe port(11211) do
  it { should be_listening }
end
