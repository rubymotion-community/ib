require "rake"

desc "Generates ui.xcodeproj and open it"
task "design" do
  IB::Project.new.write
  system "open ui.xcodeproj"
end

module IB
  PATH = File.expand_path("../ib.rb", File.dirname(__FILE__))
end