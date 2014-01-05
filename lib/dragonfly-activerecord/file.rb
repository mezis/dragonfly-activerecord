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
    after_save        :build_chunks

    # BLOB is typically 65k maximum, but in our case
    # there's a 4/3 overhead for Base64 encoding, and up to 1% overhead
    # for worst case GZip compression.
    MAX_CHUNK_SIZE = 32_768

    # max number of chunks read at a time
    MAX_CHUNK_READ = 10

    def data=(file)
      @_data = file
    end

    def data
      @_output ||= Tempfile.new('dar', encoding: 'binary').tap do |fd|
        index = 0
        while true
          range = index...(index + MAX_CHUNK_READ)
          chunklist = chunks.where(idx:range).to_a.sort_by(&:idx)
          break if chunklist.empty?
          chunklist.each { |chunk| fd.write(chunk.data) }
          index += MAX_CHUNK_READ
        end
        fd.rewind
      end
    end

    private

    def build_chunks
      # require 'pry' ; binding.pry
      chunks.delete_all
      index = 0
      while chunk = @_data.read(MAX_CHUNK_SIZE)
        chunks.create!(data:chunk, idx:index)
        index += 1
      end
    end

    def set_defaults
      self.metadata    ||= Hash.new
      self.accessed_at ||= Time.current
    end
  end
end
