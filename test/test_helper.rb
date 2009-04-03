require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'active_record'

require File.join(File.dirname(__FILE__), "../lib/interrogation")

ActiveRecord::Base.logger = Logger.new(File.open('test.log', 'a'))
ActiveRecord::Base.logger.level = Logger::DEBUG
ActiveRecord::Base.colorize_logging = false

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ":memory:"
)

ActiveRecord::Schema.define do
  create_table :spoons, :force => true do |t|
    t.string :contents
    t.integer :size
  end
end

class Spoon < ActiveRecord::Base
  
  named_scope :soupy, :conditions => {:contents => 'soup'}
  named_scope :clean, :conditions => {:contents => nil}
  named_scope :bite_size, :conditions => {:size => 1..5}

  named_scope :salty, :conditions => {:flavor => 'salty'}
end