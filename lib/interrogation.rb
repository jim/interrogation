module Interrogation
  
  VERSION = '0.0.2'
  
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  # Raised when an interrogation method is called on a dirty object
  class DirtyRecordError < StandardError
  end
  
  class AttributeNotFound < StandardError
  end
  
  module InstanceMethods
    
    def in_scope?(scope, *args)
      raise Interrogation::DirtyRecordError if self.changed?
            
      conditions = self.class.send(scope, *args).proxy_options[:conditions]
      return match_against_database(scope, *args) unless conditions.is_a?(Hash)
    
      conditions.each do |attr, value|
        raise Interrogation::AttributeNotFound.new("could not find attribute '#{attr}'") unless @attributes.has_key?(attr.to_s)
        case value
        when String, Fixnum, nil
          return false unless self.read_attribute(attr) == value
        when Range
          return false unless self.read_attribute(attr) === value
        when Array
          return false unless value.include?(self.read_attribute(attr))
        else
          return match_against_database(scope, *args)
        end
      end
      
      true    
    end
    
    protected
    
    def match_against_database(scope, *args)
      self.class.send(scope, *args).count(:conditions => {:id => self.id}) > 0
    end
    
  end
  
  module ActiveRecordMagic

    def self.included(base)
      base.send(:include, ClassMethods)
      base.alias_method_chain :named_scope, :interrogation
    end
    
    module ClassMethods
      def named_scope_with_interrogation(name, options = {}, &block)
        named_scope_without_interrogation(name, options, &block)
        accessor_name = "#{name}?"
        unless method_defined?(accessor_name)
          src = <<-RUBY
            def #{accessor_name}(*args)
              self.in_scope?(:'#{name}', *args)
            end
          RUBY
          module_eval(src, __FILE__, __LINE__)
        end
      end
    end
  end
  
end

ActiveRecord::Base.send(:include, Interrogation)
ActiveRecord::NamedScope::ClassMethods.send(:include, Interrogation::ActiveRecordMagic)