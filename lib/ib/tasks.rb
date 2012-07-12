require "rake"

desc "Generates ui.xcodeproj and open it"
task "design" do
  IB::Project.new.write
  system "open ui.xcodeproj"
end