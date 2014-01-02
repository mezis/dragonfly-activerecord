require 'dragonfly-activerecord'
require 'dragonfly-activerecord/chunk'
require 'active_record'

module Dragonfly::ActiveRecord
  class File < ActiveRecord::Base
    self.table_name = 'storage_files'

    has_many :chunks, class_name: 'Dragonfly::ActiveRecord::Chunk', autosave: true, dependent: :delete_all, inverse_of: :file

    serialize :metadata
    validates_presence_of :metadata
    validates_presence_of :accessed_at

    before_validation :set_defaults

    # default_value_for(:metadata) { Hash.new }
    # default_value_for(:accessed_at) { Time.current }

    # BLOB is typically 65k maximum, but in our case
    # there's a 4/3 overhead for Base64 encoding, and up to 1% overhead
    # for worst case GZip compression.
    MAX_CHUNK_SIZE = 32_768

    def data=(data)
      self.chunks.each(&:mark_for_destruction)
      (data.length / MAX_CHUNK_SIZE + 1).times do |index|
        chunk = data[index * MAX_CHUNK_SIZE, MAX_CHUNK_SIZE]
        self.chunks.new(data:chunk, idx:index)
      end
    end

    def data
      self.chunks.order(:idx).map(&:data).join
    end

    private

    def set_defaults
      self.metadata    ||= Hash.new
      self.accessed_at ||= Time.current
    end
  end
end
