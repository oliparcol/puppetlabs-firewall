# frozen_string_literal: true

require 'spec_helper'

describe 'Facter::Util::Fact iptables_persistent_version' do
  context 'when iptables-persistent applicable' do
    before(:each) { Facter.clear }

    let(:dpkg_cmd) { "dpkg-query -Wf '${Version}' netfilter-persistent 2>/dev/null" }

    {
      'Ubuntu' => '0.5.3ubuntu2'
    }.each do |os, ver|
      os_release = '20.04'

      describe "#{os} package installed" do
        before(:each) do
          allow(Facter.fact(:'os.name')).to receive(:value).and_return(os)
          allow(Facter.fact(:'os.release.full')).to receive(:value).and_return(os_release)
          allow(Facter::Core::Execution).to receive(:execute).with(dpkg_cmd, { on_fail: nil })
                                                             .and_return(ver)
        end

        it { expect(Facter.fact(:iptables_persistent_version).value).to eql ver }
      end
    end

    describe 'Ubuntu package not installed' do
      before(:each) do
        allow(Facter.fact(:'os.name')).to receive(:value).and_return('Ubuntu')
        allow(Facter.fact(:'os.release.full')).to receive(:value).and_return('20.04')
        allow(Facter::Core::Execution).to receive(:execute).with(dpkg_cmd, { on_fail: nil })
                                                           .and_return(nil)
      end

      it { expect(Facter.fact(:iptables_persistent_version).value).to be_nil }
    end

    describe 'CentOS not supported' do
      before(:each) do
        allow(Facter.fact(:'os.name')).to receive(:value)
          .and_return('CentOS')
      end

      it { expect(Facter.fact(:iptables_persistent_version).value).to be_nil }
    end
  end

  context 'when netfilter-persistent applicable' do
    before(:each) { Facter.clear }

    let(:dpkg_cmd) { "dpkg-query -Wf '${Version}' netfilter-persistent 2>/dev/null" }

    {
      'Debian' => '0.0.20090701',
      'Ubuntu' => '0.5.3ubuntu2'
    }.each do |os, ver|
      if os == 'Debian'
        os_release = '8.0'
      elsif os == 'Ubuntu'
        os_release = '14.10'
      end

      describe "#{os} package installed" do
        before(:each) do
          allow(Facter.fact(:'os.name')).to receive(:value).and_return(os)
          allow(Facter.fact(:'os.release.full')).to receive(:value).and_return(os_release)
          allow(Facter::Core::Execution).to receive(:execute).with(dpkg_cmd, { on_fail: nil })
                                                             .and_return(ver)
        end

        it { expect(Facter.fact(:iptables_persistent_version).value).to eql ver }
      end
    end

    describe 'Ubuntu package not installed' do
      os_release = '14.10'
      before(:each) do
        allow(Facter.fact(:'os.name')).to receive(:value).and_return('Ubuntu')
        allow(Facter.fact(:'os.release.full')).to receive(:value).and_return(os_release)
        allow(Facter::Core::Execution).to receive(:execute).with(dpkg_cmd, { on_fail: nil })
                                                           .and_return(nil)
      end

      it { expect(Facter.fact(:iptables_persistent_version).value).to be_nil }
    end

    describe 'CentOS not supported' do
      before(:each) do
        allow(Facter.fact(:'os.name')).to receive(:value)
          .and_return('CentOS')
      end

      it { expect(Facter.fact(:iptables_persistent_version).value).to be_nil }
    end
  end
end
