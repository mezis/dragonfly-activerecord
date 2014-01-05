require 'spec_helper'
require 'dragonfly-activerecord/store.rb'
require 'dragonfly'

describe Dragonfly::ActiveRecord::Store do

  let(:fake_file) do
    Dragonfly::Content.new(
      nil, # no app
      Dragonfly::TempObject.new(data),
      metadata)
  end

  let(:metadata) { {a:1} }

  before { prepare_database }

  share_examples_for 'store and retrieve' do
    it 'retrieves the data' do
      id = subject.write(fake_file)
      returned_data, returned_meta = subject.read(id)

      returned_data.length.should == data.length
      returned_data.read.should == data
    end
  end


  context 'for small chunks of text data' do
    let(:data) { "foobar" }
    it_should_behave_like 'store and retrieve'
  end

  context 'for small chunks of binary data' do
    let(:data) { SecureRandom.random_bytes(64) }
    it_should_behave_like 'store and retrieve'
  end

  context 'for large chunks of binary data' do
    let(:data) { SecureRandom.random_bytes(2_000_000) }
    it_should_behave_like 'store and retrieve'
  end

  it 'returns nil for missing files' do
    subject.read('1337').should be_nil
  end
end
