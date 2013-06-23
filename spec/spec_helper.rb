require 'puppet'
require 'rspec-puppet'
require 'tmpdir'

RSpec.configure do |c|
  c.before :each do
    # Create a temporary puppet confdir area and temporary site.pp so
    # when rspec-puppet runs we don't get a puppet error.
    @puppetdir = Dir.mktmpdir("jerger")
    manifestdir = File.join(@puppetdir, "manifests")
    Dir.mkdir(manifestdir)
    FileUtils.touch(File.join(manifestdir, "site.pp"))
    Puppet[:confdir] = @puppetdir
  end

  c.after :each do
    FileUtils.rm_rf(Dir.glob('/tmp/jerger20*') , :secure => true)
  end

  c.module_path = "../../puppet-modules-politaktiv:../../puppet-modules-dda:../../puppet-modules-nextgen42"
end