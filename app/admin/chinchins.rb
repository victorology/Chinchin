ActiveAdmin.register Chinchin do
   index do
   	column "ID", :id
  	column "Name", :name
  	column "Gender", :gender
  	column "Language", :locale
  	column "Join Date", :created_at
  	column "Update Date", :updated_at
  	default_actions
  end
end
