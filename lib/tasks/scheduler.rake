desc "This task is called by the Heroku scheduler add-on"
task :generate_report => :environment do
  puts "Generating report..."
  today_string = Time.now.strftime("%Y-%m-%d")
  puts "start with #{today_string}"
  Report.store_report_data(today_string, today_string)
  puts "done."
end