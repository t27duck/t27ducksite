# frozen_string_literal: true

namespace :auth do
  desc "Generates YAML to put in .authentication.yml"
  task generate: :environment do
    require "bcrypt"
    require "io/console"
    require "securerandom"
    require "yaml"

    puts "New password:"
    password = STDIN.noecho(&:gets).strip
    puts "New password (confirmation):"
    password_confirmation = STDIN.noecho(&:gets).strip
    if password == password_confirmation
      hash = {
        "session_token" => SecureRandom.hex,
        "password_digest" => BCrypt::Password.create(password).to_s
      }
      puts "CONTENT FOR .authentication.yml:"
      puts hash.to_yaml
    else
      puts "ERROR: Passwords do not match"
    end
  end
end
