require 'rake' unless defined? Rake

namespace :ib do
  desc "Generates ib.xcodeproj and opens it in XCode"
  task :open => :project do
    system "open ib.xcodeproj"
  end

  desc "Generates ib.xcodeproj"
  task :project do
    IB::Project.new.write
  end
end