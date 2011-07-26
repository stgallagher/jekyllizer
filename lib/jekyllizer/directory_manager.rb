require 'fileutils'

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

    def changed_directory
      dir = File.dirname(@destination)
      subdir = @file_changer.filename.match(/([^\/]*)\/[^\/]*\.html/).captures.to_s
      @changed_directory =  dir + "/" + subdir + "/_posts/"
    end

    def changed_basename
      @basename = @file_changer.formatted_filename
    end

    def changed_file_contents
      @file_changer.replace_header
    end

    def html_files
      @html_files
    end

    def change_files
      @html_files.each do |file|
       #puts "In change files: File is => " + file
        pass_file_to_changer(file)
        changed_directory
        changed_basename
        "changed directory is =>"
        @changed_directory
        "changed basename is =>"
        @basename
        if(File.directory?(@changed_directory))
         FileUtils.chdir(@changed_directory)
        else
         FileUtils.mkdir_p(@changed_directory)
         FileUtils.chdir(@changed_directory)
        end
        File.open(@basename, "w+") do |line| 
          line << changed_file_contents
        end       
      end 
    end
  end
end
