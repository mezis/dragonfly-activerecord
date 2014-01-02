require 'dragonfly-activerecord'

module Dragonfly::ActiveRecord
  module Migration
    def up
      create_table :storage_chunks do |t|
        t.integer :file_id
        t.integer :idx
        t.binary  :encoded_data, limit: 65_536
      end

      add_index :storage_chunks, :file_id, using: 'hash'

      create_table :storage_files do |t|
        t.text     :metadata
        t.datetime :accessed_at
        t.timestamps
      end
    end

    def down
      drop_table :storage_chunks
      drop_table :storage_files
    end
  end
end

