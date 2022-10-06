require File.expand_path(File.dirname(__FILE__) + '/environment')

set :environment, :development
set :output, "#{Rails.root}/log/cron.log"
job_type :rake, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

every 1.day, at: '7:00 am' do
  rake 'moon_notification:push_line_message'
end