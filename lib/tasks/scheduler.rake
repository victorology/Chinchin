desc "This task is called by the Heroku scheduler add-on"
task :generate_report => :environment do
  puts "Generating report..."
  Report.generate
  puts "done."
end