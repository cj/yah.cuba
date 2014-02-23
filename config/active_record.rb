ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
    adapter: 'mysql2',
    encoding: 'utf8',
    reconnect: true,
    database: 'yah',
    host: 'localhost',
    port: 3306,
    pool: 5,
    username: 'root',
    password: ''
)

require 'mini_record'

Dir["./app/models/**/*.rb"].each  { |rb| require rb  }
