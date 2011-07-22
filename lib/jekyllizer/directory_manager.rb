
module Jekyllizer
  class DirectoryManager 
   
    def initialize(source, destination)
      @source = source
      @destination = destination
      @html_files = Dir["#{@source}/**/*.html"]
    end

    def source
      @source
    end

    def source=(source)
      @source = source
      @file_changer.filename= source
      @html_files = Dir["#{@source}/**/*.html"]
    end

    def destination
      @destination
    end

    def changer
      @file_changer = FileChanger.new
    end
    
    def file_changer
      @file_changer
    end

    def pass_files_to_changer
      @file_changer.filename= @html_files[0]
    end

    def changed_filename
      basename = @file_changer.formatted_filename
      dir = File.dirname(@source)
      changed_filename = dir + "/" + basename 
    end

    def changed_file_contents
      @file_changer.replace_header
    end

    def html_files
      @html_files
    end

  end
end
