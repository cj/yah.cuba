module Environment
  def environment
    ENV["RACK_ENV"]
  end

  def development?
    environment == "development"
  end

  def production?
    environment == "production"
  end

  def test?
    environment == "test"
  end

  module ClassMethods
    def environment
      ENV["RACK_ENV"]
    end

    def development?
      environment == "development"
    end

    def production?
      environment == "production"
    end

    def test?
      environment == "test"
    end
  end
end
