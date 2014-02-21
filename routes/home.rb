module Routes
  class Home < Cuba
    define do
      on root do
        res.write view("home/index")
      end
    end
  end
end
