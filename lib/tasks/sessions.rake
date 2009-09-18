namespace :db do
  namespace :sessions do
    desc 'Remove old data from the sessions table'
    task(:expire => :environment) do
      ActiveRecord::Base.connection.execute('DELETE FROM sessions WHERE `created_at` < DATE_SUB(CURDATE(), INTERVAL 2 MONTH)')
    end
  end
end

