namespace :db do
  namespace :sessions do
    namespace :clear do
      desc 'Remove expired sessions'
      task(:expired => :environment) do
        ActiveRecord::Base.connection.execute('DELETE FROM sessions WHERE `created_at` < DATE_SUB(CURDATE(), INTERVAL 2 MONTH)')
      end

      desc 'Remove inactive sessions'
      task(:inactive => :environment) do
        ActiveRecord::Base.connection.execute('DELETE FROM sessions WHERE `updated_at` < DATE_SUB(CURDATE(), INTERVAL 1 MONTH)')
      end
    end
  end
end

