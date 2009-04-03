module Interrogation
  
  VERSION = '0.0.2'
  
  def self.included(base)
    base.send(:include, ClassMethods)
    base.alias_method_chain :named_scope, :interrogation
  end
  
  class DirtyRecordError < StandardError #:nodoc:
  end
  
  module ClassMethods
    def named_scope_with_interrogation(name, options = {}, &block)
      named_scope_without_interrogation(name, options, &block)
      accessor_name = "#{name}?"
      unless method_defined?(accessor_name)
        src = <<-RUBY
          def #{accessor_name}(*args)
            raise Interrogation::DirtyRecordError if self.changed?
            self.class.send(:#{name}, *args).count(:conditions => {:id => self.id}) > 0
          end
        RUBY
        module_eval(src, __FILE__, __LINE__)
      end
    end
  end  
end

ActiveRecord::NamedScope::ClassMethods.send(:include, Interrogation)