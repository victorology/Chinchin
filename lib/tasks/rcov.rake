require 'rspec/core/rake_task'

desc "Run all specs with rcov"
RSpec::Core::RakeTask.new("spec:coverage") do |t|
  t.rcov = true
  t.rcov_opts = %w{--rails --include views -Ispec
                  --exclude gems\/,spec\/,features\/,seeds\/}
  t.spec_opts = ["-c --drb"]
end