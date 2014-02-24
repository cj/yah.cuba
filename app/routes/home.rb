class Routes::Home < Cuba
  define do
    on get, default do
      user = UserForm.new
      user.valid?
      res.write view("home/index", user: user)
    end
  end
end
