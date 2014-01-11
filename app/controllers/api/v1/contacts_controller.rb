class API::V1::ContactsController < API::V1::BaseController
  def index
  end

  def create
    contacts = params[:contacts]
    @current_user.add_contacts(contacts)
  end
end