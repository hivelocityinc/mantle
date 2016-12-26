require 'spec_helper'

php_packages = %w{php5 php5-common php5-ctype php5-fpm php5-mysqli php5-phar php5-pdo php5-pdo_mysql php5-dom php5-gd php5-xml php5-json php5-mcrypt php5-imap php5-zlib php5-opcache php5-openssl php5-imagick php5-memcached php5-redis}

php_packages.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
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

describe file('/var/log/php-fpm/php-fpm.log') do
  it { should be_file }
end

describe file('/usr/bin/composer') do
  it { should be_file }
end

describe port(9000) do
  it { should be_listening }
end
