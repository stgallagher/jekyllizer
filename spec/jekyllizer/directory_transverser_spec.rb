require 'spec_helper'

module Jekyllizer
  describe DirectoryTransverser do
    before(:each) do
      dir_mock = mock("directory")
      dt = DirectoryTransverser.new(dir_mock)
    end

      it "opens the parent directory" do
      dir_mock = mock("directory")
      dir_mock.stub(:path).and_return("/usr/local/software/")
      dt = DirectoryTransverser.new(dir_mock)
      dt.parent_directory.should == "/usr/local/software/"
    end

    it "opens each sub-directory under the parent directory" do
      dir_mock = mock("directory")
      Dir.stub(:entries).and_return(["/billy\n", "/dave\n", "/sam\n"])
      dt = DirectoryTransverser.new(dir_mock)
      dt.get_subdirectories.should == ["/billy\n", "/dave\n", "/sam\n"]
    end

    it "sends each file in the sub-directory to the filename parser" do
      pending  
    end
  end
end
