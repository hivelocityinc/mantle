require 'spec_helper'

describe package('php5') do
  it { should be_installed }
end

describe command('php -v') do
  its(:stdout) { should match /PHP 5\.6.+/ }
end

describe port(9000) do
  it { should be_listening }
end
