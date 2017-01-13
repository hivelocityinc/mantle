require 'spec_helper'

php_packages = %w{php7 php7-common php7-ctype php7-fpm php7-mysqli php7-phar php7-pdo php7-pdo_mysql php7-dom php7-gd php7-xml php7-json php7-mcrypt php7-mbstring php7-imap php7-zlib php7-opcache php7-openssl php7-memcached php7-redis}

php_packages.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe command('php -v') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /PHP 7\.0\..+/ }
end

describe file('/etc/php7/php.ini') do
  it { should be_file }
end

describe file('/etc/php7/php-fpm.conf') do
  it { should be_file }
end

describe file('/etc/php7/php-fpm.d/www.conf') do
  it { should be_file }
end

describe file('/var/log/php-fpm') do
  it { should be_directory }
end

describe file('/usr/bin/composer') do
  it { should be_file }
end

describe port(9000) do
  it { should be_listening }
end
