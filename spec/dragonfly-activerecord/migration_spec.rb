require 'spec_helper'
require 'dragonfly-activerecord/migration'

describe Dragonfly::ActiveRecord::Migration do
  subject do
    Class.new(ActiveRecord::Migration) do
      include Dragonfly::ActiveRecord::Migration
    end
  end

  it 'is a proper migration' do
    subject.ancestors.should include(ActiveRecord::Migration)
  end

  it 'applies cleanly' do
    silence_stream(STDOUT) { subject.new.up }
  end

  it 'rolls back cleanly' do
    silence_stream(STDOUT) { subject.new.up ; subject.new.down }
  end

  context 'when applied' do
    let(:model_class) { Class.new(ActiveRecord::Base) }

    before do
      silence_stream(STDOUT) { subject.new.up }
    end

    it 'result in a functional chunks model' do
      model_class.table_name = 'storage_chunks'
      model_class.create(file_id: 123, idx: 456, encoded_data: 'foobar')
      model_class.count.should == 1
    end
    
    it 'result in a functional files model' do
      model_class.table_name = 'storage_files'
      model_class.create(metadata: 'foobar', accessed_at: Time.now)
      model_class.count.should == 1
    end
  end
end
