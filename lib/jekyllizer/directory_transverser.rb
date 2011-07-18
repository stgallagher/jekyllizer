module Jekyllizer
  class DirectoryTransverser
    
    def initialize(parent_directory)
      @parent_directory = parent_directory
    end
    
    def parent_directory
      @parent_directory.path
    end  

    def get_subdirectories
      Dir::entries
    end
  end
end
