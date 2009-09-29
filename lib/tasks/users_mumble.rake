require 'sqlite3'

namespace :users do
  namespace :mumble do
    desc 'Generate and export mumble passwords'
    task :export => :environment do
      db = SQLite3::Database.new("/var/lib/mumble-server/mumble-server.sqlite")

      db.prepare("INSERT OR IGNORE INTO players (server_id, name, pw, email, player_id )
                  VALUES (1, :name, :password, :email, (select player_id+1 from players where rowid IN (select count(*) from players)))") do |stmt|
        User.active.find_each(:batch_size => 50) do |user|
          user.create_mumble unless user.mumble
          stmt.execute(:name => user.login, :password => user.mumble.password_sha1, :email => user.email_alias)
        end
      end
    end
  end
end
