require "spec_helper"

require "ib/project"

describe IB::Project do
  it "generates xcode project" do
    IB::Project.new(app_path:"spec/fixtures/common").write()
  end

  it "app_files" do
    Motion::Project::App.config.stub('files').and_return(
      [
        '/usr/local/xxx/gems/xxx/lib/xxxx.rb',
        'User/xxx/gems/xxx/lib/motion/xxxx.rb',
        './app/aaa.rb',
        './app/controllers/bbb.rb',
      ]
    )
    expect(IB::Project.new(app_path:"spec/fixtures/common").app_files).to eq(
      ['./app/aaa.rb', './app/controllers/bbb.rb',]
    )
  end
end
