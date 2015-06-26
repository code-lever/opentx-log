require 'spec_helper'

describe OpenTx::Log::File do

  context 'data file taranis-x9d.csv' do

    before(:all) { @file = OpenTx::Log::File.new(data_file('taranis-x9d.csv')) }

    subject { @file }

    it { should have(1).sessions }

    its(:duration) { should be_within(0.1).of(85.2) }

  end

  describe '#opentx?' do

    it 'should be false for invalid or missing files' do
      files = invalid_data_files
      files.should have(7).files

      files.each do |f|
        expect(OpenTx::Log::File.opentx?(f)).to be_falsey
      end
    end

    it 'should be true for valid files' do
      files = data_files
      files.should have(1).file

      files.each do |f|
        expect(OpenTx::Log::File.opentx?(f)).to be_truthy
      end
    end

    it 'should return a file object' do
      expect(OpenTx::Log::File.opentx?(data_files[0])).to be_a(OpenTx::Log::File)
    end

    it 'should return nil when invalid' do
      expect(OpenTx::Log::File.opentx?(invalid_data_files[0])).to be_nil
    end

  end

end
