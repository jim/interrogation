require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require File.join(File.dirname(__FILE__), "../lib/interrogation")


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'test.sqlite3',
  :pool => 5,
  :timeout => 5000
)

ActiveRecord::Schema.define do
  create_table :spatulas, :force => true do |t|
    t.string :contents
  end
end


class Spatula < ActiveRecord::Base
  
  named_scope :soupy, :conditions => {:contents => 'soup'}
  named_scope :clean, :conditions => {:contents => nil}
  
end