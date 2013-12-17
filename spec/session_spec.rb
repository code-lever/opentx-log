require 'spec_helper'

describe OpenTx::Log::Session do

  context 'data file taranis-x9d.csv' do

    before(:all) { @file = OpenTx::Log::File.new(data_file('taranis-x9d.csv')) }

    subject { @file.sessions[0] }

    its(:swr?) { should be_true }

    its(:rssi?) { should be_true }

  end

end
