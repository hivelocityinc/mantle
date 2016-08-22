require 'spec_helper'

describe package('mariadb') do
  it { should be_installed }
end
