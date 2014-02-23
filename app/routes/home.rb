class Routes::Home < Cuba
  define do
    on get, default do
      res.write view("home/index", user: User.new)
    end
  end
end
