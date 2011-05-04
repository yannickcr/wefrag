namespace :users do
  desc 'Clean pending users'
  task(:clean_pending => :environment) do
    ActionMailer::Base.default_url_options[:host] = 'forum.nofrag.com'
    count = 0

    User.find(:all, 
              :conditions => [ '`users`.state IN (?, ?) AND  `users`.created_at < ?', 'pending', 'notified', 5.days.ago.to_s(:db) ],
              :order => '`users`.created_at ASC').each do |user|
      user.destroy
      puts "User \"#{user}\" has been deleted"
      count += 1
    end

    puts "-- Total: #{count} users deleted."
  end

  desc 'Clean uncomplete users'
  task(:clean_uncomplete => :environment) do
    ActionMailer::Base.default_url_options[:host] = 'forum.nofrag.com'
    count = 0

    User.find(:all, 
              :conditions => [ '`users`.state = ? AND  `users`.created_at < ?', 'confirmed', 7.days.ago.to_s(:db) ],
              :order => '`users`.created_at ASC').each do |user|
      unless user.is_complete?
        user.destroy
        puts "User \"#{user}\" has been deleted"
        count += 1
      end
    end

    puts "-- Total: #{count} users deleted."
  end

  desc 'Clean refused users'
  task(:clean_refused => :environment) do
    ActionMailer::Base.default_url_options[:host] = 'forum.nofrag.com'
    count = 0

    User.find(:all, 
              :conditions => [ '`users`.state = ?', 'refused' ],
              :order => '`users`.created_at ASC').each do |user|
      user.destroy
      puts "User \"#{user}\" has been deleted"
      count += 1
    end

    puts "-- Total: #{count} users deleted."
  end

  desc 'Setup users email forwarding'
  task(:setup_email => :environment) do
    require "ftools"

    count = 0

    puts "Exporting emails to /etc/postfix/virtual..."

    tmp = Tempfile.new('user_emails')
    users = User.find(:all, :include => :info, :conditions => [ '`users`.state = ? AND `users`.id > ? AND (`user_infos`.is_email IS NULL OR `user_infos`.is_email = ?)', 'active', 0, true ], :limit => 50)
    while users.any?
       users.each do |user|
         tmp.puts "#{user.email_alias}\t#{user.email}"
         count += 1
       end
       users = User.find(:all, :include => :info, :conditions => [ '`users`.state = ? AND `users`.id > ? AND (`user_infos`.is_email IS NULL OR `user_infos`.is_email = ?)', 'active', users.last.id, true ], :limit => 50)
    end
    tmp.close
    File.copy(tmp.path, '/etc/postfix/virtual')
    File.chmod(0644, '/etc/postfix/virtual')
    tmp.unlink

    puts "Reloading postfix config..."
    `postmap /etc/postfix/virtual && postfix reload`

    puts "-- Total: #{count} emails."
  end
end
