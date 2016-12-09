require 'spec_helper'

describe command('supervisorctl status') do
  its(:exit_status) { should eq 0 }
end
