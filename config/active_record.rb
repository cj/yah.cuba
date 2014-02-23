ActiveRecord::Base.logger = Logger.new(STDERR)

#These Settings Establish the Proper Database Connection for Heroku Postgres
#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path

db = URI.parse ENV['DATABASE_URL']

ActiveRecord::Base.establish_connection(
    adapter: db.scheme == 'postgres' ? 'pg' : db.scheme,
    encoding: 'utf8',
    reconnect: true,
    database: db.path[1..-1],
    host: db.host,
    port: db.port,
    pool: ENV['DATABASE_POOL'] || 5,
    username: db.user,
    password: db.password
)

require 'mini_record'

Dir["./app/models/**/*.rb"].each  { |rb| require rb  }
