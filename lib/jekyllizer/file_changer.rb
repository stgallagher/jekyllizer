
module Jekyllizer
  class FileChanger
    
    def filename=(filename)
      @filename = filename
    end

    def filename
      return @filename
    end
 
    def file_contents
      @file_contents = IO.readlines(@filename)
    end

    def get_file_contents
      @file_contents
    end

    def title_line
      @title_line = @file_contents[0]
    end
    
    def remove_header_tags_from_title
      @title_line.gsub!(/<h1>/, "")
      @title_line.gsub!(/<\/h1>/, "")
    end
    
    def remove_newline_from_title
      @title_line.gsub!(/\n/,"")
    end
    
    def remove_punctuation_marks_from_title
      @title_line.gsub!(/[.|,|:|;|(|)|!]/,"")
    end
    
    def hyphenate_title
      @title_line.gsub!(/\s/,"-")
    end
    
    def downcase_title
      @title_line.downcase!
    end

    def basename
      @basename = @filename.match(/\A.+\/(.+)\z/).captures.to_s 
    end

    def basename_date
      @date = @basename.match(/(\d+)/).captures.to_s
    end
    
    def hyphenate_date
      @date.insert(4, "-")    
      @date.insert(7, "-")    
    end
    
    def formatted_filename
      file_contents
      title_line
      remove_header_tags_from_title
      remove_newline_from_title 
      remove_punctuation_marks_from_title
      hyphenate_title 
      downcase_title
      basename
      basename_date
      hyphenate_date
      return "#{@date}-#{@title_line}.html"
    end

    def text_body_title
      file_contents
      text_body_title = @file_contents[0]
      text_body_title.gsub!(/<h1>/, "")
      text_body_title.gsub!(/<\/h1>/, "")
      text_body_title.gsub!(/\n/,"")
    end

    def replace_header
      file_contents
      @file_contents = @file_contents.drop(3)
      @file_contents = @file_contents.insert(0, "---\n",
                            "layout: post\n",
                            "title: #{text_body_title}\n",
                            "tag:\n",
                            "---\n",
                            "\n")
    end

  end
end
