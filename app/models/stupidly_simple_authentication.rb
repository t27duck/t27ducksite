require 'bcrypt'

class StupidlySimpleAuthentication
  def self.authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  def self.authenticated?(token)
    session_token == token
  end

  def self.session_token
    config['session_token'] || raise('Session token not set')
  end

  def self.config
    @config ||= configure!
  end
  private_class_method :config

  def self.configure!
    @config = YAML::load_file("#{Rails.root}/.authentication.yml")
  end
  private_class_method :configure!

  def self.password_digest
    config['password_digest'] || raise('Digest not set')
  end
  private_class_method :password_digest
end
