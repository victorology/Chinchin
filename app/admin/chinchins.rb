ActiveAdmin.register Chinchin do
   index do
  	column "Name", :name
  	column "Gender", :gender
  	column "Language", :locale
  	column "Join Date", :created_at
  	column "Update Date", :updated_at
  end
end
