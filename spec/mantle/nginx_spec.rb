require 'spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe command('nginx -v') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match /nginx version: nginx\/1\.10\..+/ }
end

describe file('/etc/nginx/nginx.conf') do
  it { should be_file }
end

describe file('/etc/nginx/conf.d/default.conf') do
  it { should be_file }
end

describe command('nginx -t') do
  its(:exit_status) { should eq 0 }
end

describe process("nginx") do
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end
