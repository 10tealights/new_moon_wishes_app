module AuthHelper
  def auth_stub
    allow_any_instance_of(UsersController).to receive(:current_user).and_return(current_user)
  end
end
