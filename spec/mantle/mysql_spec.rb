require 'spec_helper'

describe package('mariadb') do
  it { should be_installed }
end

describe command('mysql -V') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /mysql  Ver 15\.1 Distrib 10\.1\..+/ }
end

describe file('/etc/mysql/my.cnf') do
  it { should be_file }
end

describe file('/var/lib/mysql') do
  it { should be_directory }
end

describe file('/var/run/mysqld') do
  it { should be_directory }
end

describe file('/var/log/mysql/error.log') do
  it { should be_file }
end

describe file('/var/run/mysqld/mysqld.sock') do
  it { should be_socket }
end

describe command('/usr/bin/mysqladmin ping -uroot -proot') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /mysqld is alive/ }
end

describe port(3306) do
  it { should be_listening }
end
