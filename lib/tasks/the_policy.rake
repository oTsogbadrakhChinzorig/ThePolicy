namespace :db do
  namespace :the_policy do

    # rake db:the_policy:operator
    desc 'create Operator Policy'
    task :operator => :environment do
      unless Policy.with_name(:operator)
        ThePolicy.create_operator!
        puts "ThePolicy >>> Operator policy created"
      else
        puts "ThePolicy >>> Operator policy exists"
      end
    end

  end
end
