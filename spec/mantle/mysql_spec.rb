require 'spec_helper'

describe package('mariadb') do
  it { should be_installed }
end

describe command('mysql -V') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /mysql  Ver 15\.1 Distrib 10\.1\..+/ }
end

describe port(3306) do
  it { should be_listening }
end
