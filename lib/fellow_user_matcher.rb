class FellowUserMatcher
  class << self
    def match email
      user = User.find_by email: email
      fellow = Fellow.includes(:contact).where(contacts: {email: email}).first

      if user && fellow
        user.fellow = fellow
      end
    end
  end
end