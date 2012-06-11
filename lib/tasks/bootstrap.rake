namespace :db do
  desc 'Bootstraps the database with initial data'
  task bootstrap: :environment do
    system 'clear'
    puts "Bootstrapping...\n\n"

    if User.count > 0
      puts "The first user already exists!"
    else
      puts "Let's create the first user!"
      user_attributes = {}

      print "What's your name? => "
      user_attributes[:name] = STDIN.gets.chomp.strip

      print "What's your e-mail? => "
      user_attributes[:email] = STDIN.gets.chomp.strip

      print 'Enter a password => '
      system 'stty -echo'
      user_attributes[:password] = STDIN.gets.chomp.strip
      system 'stty echo'
      puts

      print "Confirm the password => "
      system 'stty -echo'
      user_attributes[:password_confirmation] = STDIN.gets.chomp.strip
      system 'stty echo'
      puts

      user = User.new(user_attributes)

      if user.save
        puts "\nUser was successfully created!"
      else
        puts "\nSomething went wrong.\nUser was NOT created!"
      end
    end
  end
end
