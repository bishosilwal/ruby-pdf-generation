module ShareHelper
	 def user_id(email)
    user=User.find_by(email: email)
    return user.id unless user.nil? 
  end
end
