require 'mini_record'

ActiveRecord::Base.logger = Logger.new(STDERR)

#These Settings Establish the Proper Database Connection for Heroku Postgres
#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path

db = URI.parse ENV['DATABASE_URL']

ActiveRecord::Base.establish_connection(
    adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    encoding: 'utf8',
    reconnect: true,
    database: db.path[1..-1],
    host: db.host,
    port: db.port,
    pool: ENV['DATABASE_POOL'] || 5,
    username: db.user,
    password: db.password
)

module ActiveForm
  extend ActiveSupport::Concern

  included do
    def is_form?
      self.class.model_name.to_s[/Form$/]
    end
  end
end

ActiveRecord::Base.send :include, ActiveForm

Dir["./app/models/*.rb"].each  { |rb| require rb  }
Dir["./app/models/**/*.rb"].each  { |rb| require rb  }
