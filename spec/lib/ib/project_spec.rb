require "spec_helper"

require "ib/project"

describe IB::Project do

  context 'structure' do
    let(:project) { described_class.new(project_path: 'spec/fixtures/common')}

    it "defines #write" do
      expect(project).to respond_to :write
    end

    it "defines #project" do
      expect(project).to respond_to :project
    end

    it "defines #target" do
      expect(project).to respond_to :target
    end

    it "defines #generator and is an IB::Generator" do
      expect(project).to respond_to :generator
      expect(project.generator).to be_kind_of IB::Generator
    end

    it "defines #resources" do
      expect(project).to respond_to :resources
    end

    it "defines #support_files" do
      expect(project).to respond_to :support_files
    end

    it "defines #pods" do
      expect(project).to respond_to :pods
    end

    it "defines #detect_platform" do
      expect(project).to respond_to :detect_platform
    end
  end

  describe '#initialize' do
    it "sets right path for xcode project" do
      project = described_class.new(project_path: 'spec/fixtures/common')
      expect(project.ib_project_path).to eq 'spec/fixtures/common/ib.xcodeproj'
    end
  end

  context 'creating groups' do
    let(:project) { described_class.new }

    describe '#resources' do
      it 'creates a group called Resources' do
        expect(project.resources.name).to eq 'Resources'
      end
      it 'does not create multiple group records' do
        project.resources
        project.resources
        resources = project.project.groups.select { |g| g.name == 'Resources'}
        expect(resources.length).to be 1
      end
    end

    describe '#support_files' do
      it 'creates a group called Support Files' do
        expect(project.support_files.name).to eq 'Supporting Files'
      end
    end

    describe '#pods' do
      it 'creates a group called Pods' do
        expect(project.pods.name).to eq 'Pods'
      end
    end
  end

  describe '#detect_platform' do
    it 'defaults to ios' do
      project = described_class.new
      expect(project.platform).to eq :ios
    end

    it 'can be set from parameter' do
      project = described_class.new platform: :osx
      expect(project.platform).to eq :osx
    end
  end

  describe '#app_files' do
    before do
      Motion::Project::App.config.stub('files').and_return(
        [
          '/usr/local/xxx/gems/xxx/lib/xxxx.rb',
          'User/xxx/gems/xxx/lib/motion/xxxx.rb',
          './app/aaa.rb',
          './app/controllers/bbb.rb',
        ]
      )
    end
    it "returns a list of files under app directory of the project" do
      expect(IB::Project.new.app_files).to eq ['./app/aaa.rb', './app/controllers/bbb.rb']
    end
  end
end
