# frozen_string_literal: true

set :output, "#{path}/log/cron.log"

every :day, at: "24:00" do
  rake "sample:load"
end

# For backup database
every :day, at: "24:00" do
  command "backup perform -t db_backup"
end
