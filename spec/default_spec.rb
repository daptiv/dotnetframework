describe 'dotnetframework::default' do
  describe '.NET is not installed' do
    before(:each) do
      allow_any_instance_of(Chef::Resource)
      .to receive(:registry_value_exists?)
      .with('HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full',
        { :name=>'Version', :type=>:string, :value=>'4.5.51650' }, :machine)
      .and_return(false)
    end
    let(:chef_run) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end
    it 'should install .NET 4.5.2' do
      expect(chef_run).to install_windows_package('Microsoft .NET Framework 4.5.2')
    end
    it 'should notify windows_reboot resource' do
      win_pkg = chef_run.windows_package('Microsoft .NET Framework 4.5.2')
      expect(win_pkg).to notify('windows_reboot[60]').to(:request).immediately
    end
  end
  describe '.NET is installed' do
    before(:each) do
      allow_any_instance_of(Chef::Resource)
      .to receive(:registry_value_exists?)
      .with('HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full',
        { :name=>'Version', :type=>:string, :value=>'4.5.51650' }, :machine)
      .and_return(true)
    end
    let(:chef_run) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end
    it 'should not install .NET 4.5.2' do
      expect(chef_run).to_not install_windows_package('Microsoft .NET Framework 4.5.2')
    end
  end
end
