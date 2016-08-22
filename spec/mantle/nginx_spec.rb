require 'spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe command('nginx -v') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match /nginx version: nginx\/1\.10\..+/ }
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
