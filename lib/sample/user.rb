module Sample
  class User
    def self.load
      u = ::User.create(email: "sokly@instedd.org", password: '123456')
      u.confirm
    end
  end
end
