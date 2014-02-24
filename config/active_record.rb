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

  module ClassMethods
    def columns_hash
      super.merge Thread.current["extra_columns_hash"]
    end

    def fake name, options
      attr_accessor name

      # what's the difference between using @ or Thread.current
      Thread.current["extra_columns_hash"] ||= {}
      Thread.current["extra_columns_hash"][name.to_s] = \
        ActiveRecord::ConnectionAdapters::Column.new(
          name.to_s, (options[:default] || nil), (options[:as] || :string), true
        )
    end
  end
end

ActiveRecord::Base.send :include, ActiveForm

Dir["./app/models/*.rb"].each  { |rb| require rb  }
Dir["./app/models/**/*.rb"].each  { |rb| require rb  }

module CurrentUser
  def current_user
    authenticated(User)
  end
end

Cuba.plugin CurrentUser
