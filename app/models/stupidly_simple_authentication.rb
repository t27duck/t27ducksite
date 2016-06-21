require 'bcrypt'

class StupidlySimpleAuthentication
  @config = {}

  def self.authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  def self.authenticated?(token)
    session_token == token
  end

  def self.password_digest
    @config['password_digest'] || raise('Digest not set')
  end
  private_class_method :password_digest

  def self.session_token
    @config['session_token'] || raise('Session token not set')
  end

  def self.configure!(path="#{Rails.root}/.authentication.yml")
    @config = YAML::load_file(path)
  end
end
