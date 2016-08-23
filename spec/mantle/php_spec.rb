require 'spec_helper'

describe package('php5') do
  it { should be_installed }
end

describe command('php -v') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /PHP 5\.6\..+/ }
end

describe file('/etc/php5/php.ini') do
  it { should be_file }
end

describe file('/etc/php5/php-fpm.conf') do
  it { should be_file }
end

describe port(9000) do
  it { should be_listening }
end
