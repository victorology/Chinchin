class API::V1::UsersController < API::V1::BaseController
  def show
    @current_user
  end
end