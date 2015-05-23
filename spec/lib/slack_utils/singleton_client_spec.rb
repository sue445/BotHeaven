require 'rails_helper'

describe SlackUtils::SingletonClient do
  describe '#new' do
    it 'can not call' do
      expect {
        SlackUtils::SingletonClient.new
      }.to raise_error
    end
  end

  describe '.instance' do
    it 'Return instance of SingletonClient' do
      expect(SlackUtils::SingletonClient.instance).to be_kind_of(SlackUtils::SingletonClient)
    end
  end
end
