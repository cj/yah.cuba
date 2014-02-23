module Routes
  class Home < Cuba
    define do
      on default do
        res.write view("home/index", user: User.new)
      end
    end
  end
end
