desc "This task is called by the Heroku scheduler add-on"
task :generate_report => :environment do
  puts "Generating report..."
  today_string = 1.day.ago.strftime("%Y-%m-%d")
  puts "start with #{today_string}"
  Report.store_report_data(today_string, today_string)
  puts "done."
end

task :check_and_ring_alarm => :environment do
  CurrencyAlarm.check_and_ring
end