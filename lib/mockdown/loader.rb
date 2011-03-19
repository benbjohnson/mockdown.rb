module Mockdown
  # This class loads component descriptors by name. Standard components are
  # registered with their class but user-defined components can be loaded from
  # the file system.
  class Loader
    ############################################################################
    # Constructor
    ############################################################################
    
    def initialize()
      @registry = {}
      register_class('row', Component::Row)
      register_class('col', Component::Column)
    end
    
    
    ############################################################################
    # Attributes
    ############################################################################
    
    # The paths that the loader searches to find user-defined components.
    attr_accessor :paths

    
    ############################################################################
    # Methods
    ############################################################################
    
    # Finds a descriptor by name. The loader will first search the system
    # components and then attempt to search the paths.
    #
    # @param [String] name  the name of the component.
    # @return [Mockdown::Component::Descriptor]  the descriptor associated with
    #                                            the component name.
    def find(name)
      # Return the cached or system component descriptor.
      if @registry.key?(name)
        return @registry[name]
      end
      
      # If not cached, search the available paths.
      if paths
        # TODO: Search paths!
      end
    end
    


    ############################################################################
    protected
    ############################################################################
    
    # Registers a descriptor by name. This is to help performance so descriptors
    # don't have to be reparsed.
    def register(name, descriptor)
      if @registry.key?(name)
        raise StandardError.new(
          "A descriptor has already been registered with this name: #{name}"
        )
      else
        @registry[name] = descriptor
      end
    end
    
    # Registers a class to the loader.
    def register_class(name, clazz)
      register(name, Component::Descriptor.new(clazz))
    end
  end 
end