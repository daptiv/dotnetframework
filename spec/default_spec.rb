describe 'dotnetframework::default' do

  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  it 'should install .NET 4.5.2' do
    expect(chef_run).to install_windows_package('Microsoft .NET Framework 4.5.2')
  end
end
