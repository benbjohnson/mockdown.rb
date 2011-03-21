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
      # Throw error if a parent path is specified
      if name.index('..')
        raise StandardError.new("Cannot specify '..' in a component name")
      end
      
      # Return the cached or system component descriptor.
      if @registry.key?(name)
        return @registry[name]
      end
      
      # If not cached, search the available paths.
      if paths
        paths.each do |path|
          # Convert name to a file-based name.
          fname = name.gsub(':', '/')
          
          # Try both mkd and mkx extensions
          ['mkd', 'mkx'].each do |ext|
            filename = File.expand_path(File.join(path, "#{name}.#{ext}"))
            
            # If the file exists then parse it
            if File.exists?(filename)
              # Read and parse content into a descriptor
              content = IO.read(filename)
              parser = Parser.new()
              descriptor = parser.parse(content)
              descriptor.name = name
              
              # Cache descriptor so we don't have to reparse
              register(name, descriptor)
              
              # Return the parsed descriptor
              return descriptor
            end
          end
        end
      else
        # Throw error if no paths have been set and we have not found a system
        # component.
        raise StandardError.new("Cannot load component '#{name}' because no load paths have been set")
      end
      
      # If we haven't found a component yet, throw error
      raise StandardError.new("Cannot load component '#{name}' in paths: #{paths.join(',')}")
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