task :hello_world => :environment do
  puts "Hello world #{Time.now}"
end