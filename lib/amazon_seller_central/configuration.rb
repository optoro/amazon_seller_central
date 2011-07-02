module AmazonSellerCentral
  class Configuration
    attr_accessor :login_email, :login_password

    def login_email(val=nil)
      return @login_email unless val
      @login_email = val
    end

    def login_password(val=nil)
      return @login_password unless val
      @login_password = val
    end
  end
end
