# encoding: UTF-8

describe 'dotnetframework::default' do
  describe '.NET is not installed' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end
    it 'should install .NET 4.5.2' do
      expect(chef_run).to install_dotnetframework_version('4.5.51650')
    end
    it 'should notify windows_reboot resource' do
      win_pkg = chef_run.dotnetframework_version('4.5.51650')
      expect(win_pkg).to notify('windows_reboot[60]').to(:request).immediately
    end
  end
end
