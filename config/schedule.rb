set :output, "#{path}/log/cron.log"

every :day, at: '24:00' do
  rake "sample:load"
end
