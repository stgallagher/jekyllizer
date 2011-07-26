require 'spec_helper'
require 'fakefs'
require 'pathname'
require 'fileutils'

module Jekyllizer  
  describe DirectoryManager do
    FakeFS.activate!
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

      it "should only get html files" do
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
        @dm.changer.filename="/home/sgallagher/8thLightWork/jekyllizer/dir1/file4.html"
        @dm.file_changer.filename.should == "/home/sgallagher/8thLightWork/jekyllizer/dir1/file4.html"
      end
      
      it "should receive a changed directory" do
        @dm.changer
        @dm.pass_file_to_changer("/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/before_process/craig-demyanovich/cdemyanovich-20101220.html")
        @dm.destination="/home/sgallagher/8thLightWork/Test-Result-Data/." 
        @dm.changed_directory.should == "/home/sgallagher/8thLightWork/Test-Result-Data/craig-demyanovich/_posts/"
      end

      it "should receive a changed basename" do
        @dm.changer
        @dm.pass_file_to_changer("/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/before_process/craig-demyanovich/cdemyanovich-20101220.html")
        @dm.destination="/home/sgallagher/8thLightWork/Test-Result-Data/."
        @dm.changed_basename.should == "2010-12-20-speech-is-silver-silence-is-golden.html"
      end

      it "should receive changed file contents" do
        @dm.changer
        @dm.source="/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/before_process/craig-demyanovich/cdemyanovich-20101220.html"
        returned_file_contents = @dm.changed_file_contents
        expected_file_contents = IO.readlines("/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/after_process/2010-12-20-speech-is-silver-silence-is-golden.html")
        returned_file_contents.should == expected_file_contents
      end

      it "should save the file under the changed filename, with the changed contents, in the destination directory" do
        FakeFS.deactivate!
        @dm.changer
        @dm.source= "/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/mass-before-process/"
        @dm.destination= "/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/mass-actual-results/."
        @dm.change_files
        processed_file1 = IO.readlines("/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/mass-actual-results/billy-whited/_posts/2011-03-09-tangible-typography.html")
        processed_file2 = IO.readlines("/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/mass-actual-results/colin-jones/_posts/2009-06-16-a-functional-refactoring-in-scala.html") 
        master_copy_file1 = IO.readlines("/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/mass-after-process/billy-whited/2011-03-09-tangible-typography.html")  
        master_copy_file2 = IO.readlines("/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/blog_posts/mass-after-process/colin-jones/2009-06-16-a-functional-refactoring-in-scala.html") 
        processed_file1[0..5].should == master_copy_file1[0..5]
        processed_file2[0..5].should == master_copy_file2[0..5]
      end


      it "should work" do 
        FakeFS.deactivate!
        @dm.changer
        @dm.source= "/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/Test-Blog-Data/" 
        @dm.destination= "/home/sgallagher/8thLightWork/jekyllizer/spec/fixtures/Results-Test-Blog-Data/."
        @dm.change_files
      end
  end
end
