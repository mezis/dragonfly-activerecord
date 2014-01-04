require 'dragonfly-activerecord'
require 'dragonfly-activerecord/file'
require 'active_record'

module Dragonfly::ActiveRecord
  class Store

    # +temp_object+ should respond to +data+ and +meta+
    def write(temp_object, opts={})
      File.new.tap do |file|
        file.metadata = temp_object.meta
        file.data     = temp_object.data
        file.save!
        return file.id.to_s
      end
    end

    def read(uid)
      file = File.where(id: uid.to_i).first
      return nil if file.nil?

      file.update_column(:accessed_at, Time.now)
      [ file.data, file.metadata ]
    end

    def destroy(uid)
      File.destroy(uid.to_i)
    end
  end
end
