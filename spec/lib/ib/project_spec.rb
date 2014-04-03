require "spec_helper"

require "ib/project"

describe IB::Project do
  it "defines #write" do
    expect(IB::Project.new(app_path: 'spec/fixtures/common')).to respond_to :write
  end

  it "generates xcode project" do
    project = IB::Project.new(app_path: 'spec/fixtures/common')
    project.write
  end

  describe '#app_files' do
    it "returns a list of files under app directory of the project" do
      Motion::Project::App.config.stub('files').and_return(
        [
          '/usr/local/xxx/gems/xxx/lib/xxxx.rb',
          'User/xxx/gems/xxx/lib/motion/xxxx.rb',
          './app/aaa.rb',
          './app/controllers/bbb.rb',
        ]
      )
      project = IB::Project.new(app_path: 'spec/fixtures/common')
      expect(project.app_files).to eq ['./app/aaa.rb', './app/controllers/bbb.rb']
    end
  end
end
