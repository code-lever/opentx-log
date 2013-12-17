require 'spec_helper'

describe OpenTx::Log::Session do

  context 'data file taranis-x9d.csv' do

    before(:all) { @file = OpenTx::Log::File.new(data_file('taranis-x9d.csv')) }

    subject { @file.sessions[0] }

    its(:duration) { should be_within(0.1).of(85.2) }

    it { should have(85).times }

    it { should have(85).milliseconds }

    it 'should have selected milliseconds' do
      expect(subject.milliseconds[0]).to eql(0.0)
      expect(subject.milliseconds[20]).to be_within(0.1).of(20240)
      expect(subject.milliseconds[50]).to be_within(0.1).of(50670)
      expect(subject.milliseconds[70]).to be_within(0.1).of(70980)
    end

    its(:swr?) { should be_true }

    it 'should have selected SWR values' do
      expect(subject.swr[0]).to eql(0)
      expect(subject.swr[62]).to eql(1)
      expect(subject.swr[79]).to eql(1)
    end

    its(:rssi?) { should be_true }

    it 'should have selected RSSI values' do
      expect(subject.rssi[0]).to eql(81)
      expect(subject.rssi[15]).to eql(80)
      expect(subject.rssi[53]).to eql(85)
    end

    its(:a1?) { should be_true }

    it 'should have selected A1 voltages' do
      expect(subject.a1[0]).to be_within(0.01).of(7.45)
      expect(subject.a1[27]).to be_within(0.01).of(7.45)
      expect(subject.a1[45]).to be_within(0.01).of(7.45)
      expect(subject.a1[82]).to be_within(0.01).of(7.45)
    end

    its(:a2?) { should be_false }

    its(:temp1?) { should be_true }

    it 'should have selected Temp1 temperatures (in celcius)' do
      expect(subject.temp1(:c)[0]).to be_within(0.1).of(22)
      expect(subject.temp1(:c)[27]).to be_within(0.1).of(23)
      expect(subject.temp1(:c)[45]).to be_within(0.1).of(33)
      expect(subject.temp1(:c)[82]).to be_within(0.1).of(33)
    end

    it 'should have selected Temp1 temperatures (in fahrenheit)' do
      expect(subject.temp1(:f)[0]).to be_within(0.1).of(71.6)
      expect(subject.temp1(:f)[27]).to be_within(0.1).of(73.4)
      expect(subject.temp1(:f)[45]).to be_within(0.1).of(91.4)
      expect(subject.temp1(:f)[82]).to be_within(0.1).of(91.4)
    end

    its(:fuel?) { should be_true }

    it 'should have selected fuel values' do
      expect(subject.fuel[20]).to eql(100)
      expect(subject.fuel[65]).to eql(100)
    end

  end

end
