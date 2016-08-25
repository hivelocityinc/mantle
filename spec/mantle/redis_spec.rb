require 'spec_helper'

describe package('redis') do
  it { should be_installed }
end

describe command('redis-server -v') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /Redis server v=3\.2\..+/ }
end

describe port(6379) do
  it { should be_listening }
end
