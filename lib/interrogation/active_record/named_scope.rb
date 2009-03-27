module ActiveRecord
  module NamedScope
    module ClassMethods
      def named_scope_with_boolean_accessors(name, options = {}, &block)
        named_scope_without_boolean_accessors(name, options, &block)
        accessor_name = "#{name}?"
        unless method_defined?(accessor_name)
          src = <<-RUBY
            def #{accessor_name}(*args)
              self.class.send(:#{name}, *args).count(:conditions => {:id => self.id}) > 0
            end
          RUBY
          class_eval(src, __FILE__, __LINE__)
        end
      end

      alias_method_chain :named_scope, :boolean_accessors

    end  
  end
end