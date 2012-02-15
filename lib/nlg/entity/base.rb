module Nlg
  module Entity
    module Base


      module ClassMethods
        attr_accessor :nlg_entity, :nlg_fields

        def nlg_entity(name)
          @nlg_entity = name # TODO: auto-resolve
        end
  
        def nlg_fields(*args)
          @nlg_fields ||= []
          @nlg_fields.concat args
        end
  
        def nlg_aliases
        end
      end
    end
  end
end

