namespace :auth do
  desc 'Generates YAML to put in .authentication'
  task :generate do
    require 'bcrypt'
    require 'io/console'
    require 'securerandom'
    require 'yaml'

    puts 'New password:'
    password = STDIN.noecho(&:gets).strip
    puts 'New password (confirmation):'
    password_confirmation = STDIN.noecho(&:gets).strip
    if password == password_confirmation
      hash = {
        'authentication_key' => SecureRandom.hex,
        'encrypted_password' => BCrypt::Password.create(password)
      }
      puts 'CONTENT FOR .authentication:'
      puts hash.to_yaml
    else
      puts 'ERROR: Passwords do not match'
    end
  end
end
