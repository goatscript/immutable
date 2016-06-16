require 'spec_helper'

pathway = '/root/machine.lock'

describe file pathway do
  it { should exist }
  it { should be_file }
  it { should be_immutable }
end

describe command("rm -f #{pathway}") do
  its(:exit_status) { should eq 1 }
  its(:stdout) { should_not match /rm: cannot remove \'"#{pathway}\': Operation not permitted/ }
end

