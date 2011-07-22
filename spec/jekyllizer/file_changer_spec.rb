require 'spec_helper'    

module Jekyllizer
  describe FileChanger do
    before(:each) do
      @fc = FileChanger.new
      @fc.filename= "/home/sgallagher/8thLightWork/8thlight-8th-Light-Blog-Post-Migration/craig-demyanovich/cdemyanovich-20101220.html"
    end
      
    it "should get the contents of a file" do
      @fc.file_contents.should == IO.readlines(@fc.filename) 
    end

    it "should get the first line (title line) of each file" do
      @fc.file_contents
      @fc.title_line.should == "<h1>Speech is silver; silence is golden</h1>\n"  
    end

    it "should remove the header tags from the title line" do
      @fc.file_contents
      @fc.title_line
      @fc.remove_header_tags_from_title.should == "Speech is silver; silence is golden\n"
    end

    it "should remove the newline character from the title line" do
      @fc.file_contents
      @fc.title_line
      @fc.remove_header_tags_from_title
      @fc.remove_newline_from_title.should == "Speech is silver; silence is golden"
    end

    it "should remove any punctuation marks from the title line" do
      @fc.file_contents
      @fc.title_line
      @fc.remove_header_tags_from_title
      @fc.remove_newline_from_title 
      @fc.remove_punctuation_marks_from_title.should == "Speech is silver silence is golden"
    end

    it "should hyphenate the spaces between words in the title" do
      @fc.file_contents
      @fc.title_line
      @fc.remove_header_tags_from_title
      @fc.remove_newline_from_title 
      @fc.remove_punctuation_marks_from_title
      @fc.hyphenate_title.should == "Speech-is-silver-silence-is-golden"
    end

    it "should downcase all letter characters in the title" do
      @fc.file_contents
      @fc.title_line
      @fc.remove_header_tags_from_title
      @fc.remove_newline_from_title 
      @fc.remove_punctuation_marks_from_title
      @fc.hyphenate_title 
      @fc.downcase_title.should == "speech-is-silver-silence-is-golden"
    end

    it "should get the basename from the path it is given" do 
      @fc.basename.should == "cdemyanovich-20101220.html"  
    end
    
    it "should get the date from the basename" do
      @fc.basename
      @fc.basename_date.should == "20101220"
    end

    it "should hyphenate the date" do
      @fc.basename
      @fc.basename_date
      @fc.hyphenate_date.should == "2010-12-20"
    end

    it "should compose a new file name by joining the formatted date with the title" do
      @fc.formatted_filename.should == "2010-12-20-speech-is-silver-silence-is-golden.html"
    end
      
    it "should set aside a partly-formatted title for use in altering the file text later" do
      @fc.text_body_title.should == "Speech is silver; silence is golden" 
    end

    it "should replace the header of the file with a set of specified text" do
      @fc.replace_header
      @fc.get_file_contents[0..5].should ==["---\n" ,
                                  "layout: post\n" ,
                                  "title: Speech is silver; silence is golden\n" ,
                                  "tag:\n",
                                  "---\n",
                                  "\n"]
    end
  end
end
