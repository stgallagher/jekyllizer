require 'spec_helper'
require 'fakefs'
require 'pathname'
require 'fileutils'

module Jekyllizer  
  describe DirectoryManager do
    before(:all) do
      FileUtils.touch("file1.html")
      FileUtils.touch("file2.html")
      FileUtils.touch("file3.html")
      FileUtils.mkdir("dir1")
      FileUtils.touch("dir1/file4.html")
      FileUtils.touch("dir1/file5.html")
      @dm = DirectoryManager.new(".", "./destination")
      end
      
      it "should have a source and a destination directory" do
         @dm.source.should == "."
         @dm.destination.should == "./destination" 
      end
      
      it "should get files" do
        @dm.html_files.should include(File.expand_path("file1.html"), 
                                      File.expand_path("file2.html"))
      end

      it "only gets html files" do
        FileUtils.touch("file.jpeg")
        @dm.html_files.should_not include(File.expand_path("file.jpeg"))
      end

      it "should get files recursively" do
        @dm.html_files.should include( File.expand_path("file3.html"),
                                           File.expand_path("dir1/file4.html"),
                                           File.expand_path("dir1/file5.html" ))
      end

      it "should pass a file name to changer" do
        @dm.html_files
        @dm.changer
        @dm.pass_files_to_changer
        @dm.file_changer.filename.should == "/home/sgallagher/8thLightWork/jekyllizer/dir1/file4.html"
      end

      it "should receive a changed filename" do
        @dm.changer
        @dm.source="/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/before_process/cdemyanovich-20101220.html"
        @dm.changed_filename.should == "/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/before_process/2010-12-20-speech-is-silver-silence-is-golden.html"
      end

      it "should receive changed file contents" do
        @dm.changer
        @dm.source="/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/before_process/cdemyanovich-20101220.html"
        returned_file_contents = @dm.changed_file_contents
        expected_file_contents = IO.readlines("/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/after_process/2010-12-20-speech-is-silver-silence-is-golden.html")
        returned_file_contents.should == expected_file_contents
      end
  end
end
