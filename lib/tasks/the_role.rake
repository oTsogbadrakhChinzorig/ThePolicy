namespace :db do
  namespace :the_policy do

    # rake db:the_policy:admin
    desc 'create Admin Policy'
    task :admin => :environment do
      unless Policy.with_name(:admin)
        ThePolicy.create_admin!
        puts "ThePolicy >>> Admin policy created"
      else
        puts "ThePolicy >>> Admin policy exists"
      end
    end

  end
end
