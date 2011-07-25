
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

    def destination=(destination)
      @destination = destination
    end
    
    def changer
      @file_changer = FileChanger.new
    end
    
    def file_changer
      @file_changer
    end

    def pass_file_to_changer(filename)
      @file_changer.filename= filename
    end

    def changed_filename
      dir = File.dirname(@destination)
      subdir = @file_changer.filename.match(/([^\/]*)\/[^\/]*\.html/).captures.to_s
      basename = @file_changer.formatted_filename
      
      changed_filename = dir + "/" + subdir + "/_posts/" + basename 
    end

    def changed_file_contents
      @file_changer.replace_header
    end

    def html_files
      @html_files
    end

    def change_files
      puts @html_files.size
      puts "In change_files => Source: " + @source
      @html_files.each do |file|
        puts file
        pass_file_to_changer(file)
        File.open(changed_filename, "w+") do |line| 
          line << changed_file_contents
        end       
      end 
    end
  end
end
