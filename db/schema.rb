# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140213072910) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "chinchins", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "birthday"
    t.string   "location"
    t.string   "hometown"
    t.string   "employer"
    t.string   "position"
    t.string   "gender"
    t.string   "relationship_status"
    t.string   "school"
    t.string   "locale"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
    t.integer  "photo_count"
  end

  add_index "chinchins", ["user_id"], :name => "index_chinchins_on_user_id"

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "facebook_uid"
    t.string   "facebook_username"
    t.string   "twitter_username"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "contacts", ["facebook_uid"], :name => "index_contacts_on_facebook_uid"
  add_index "contacts", ["phone_number"], :name => "index_contacts_on_phone_number"
  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "currencies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "currency_type"
    t.integer  "max_count"
    t.integer  "current_count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "currencies", ["user_id"], :name => "index_currencies_on_user_id"

  create_table "currency_alarms", :force => true do |t|
    t.integer  "currency_id"
    t.integer  "alarm_type"
    t.integer  "status"
    t.datetime "set_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "currency_alarms", ["currency_id"], :name => "index_currency_alarms_on_currency_id"

  create_table "currency_logs", :force => true do |t|
    t.integer  "currency_id"
    t.string   "action"
    t.integer  "value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "via"
  end

  add_index "currency_logs", ["currency_id"], :name => "index_currency_logs_on_currency_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "feeds", :force => true do |t|
    t.string   "feed_type"
    t.string   "message"
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "feeds", ["target_user_id"], :name => "index_feeds_on_target_user_id"
  add_index "feeds", ["user_id"], :name => "index_feeds_on_user_id"

  create_table "friendships", :force => true do |t|
    t.integer  "chinchin_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "friendships", ["user_id", "chinchin_id"], :name => "index_friendships_on_user_id_and_chinchin_id"

  create_table "invitations", :force => true do |t|
    t.integer  "chinchin_id"
    t.integer  "user_id"
    t.string   "via"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "invitations", ["chinchin_id"], :name => "index_invitations_on_chinchin_id"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "jumps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "from"
    t.integer  "to"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "jumps", ["user_id"], :name => "index_jumps_on_user_id"

  create_table "likes", :force => true do |t|
    t.integer  "chinchin_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "likes", ["chinchin_id"], :name => "index_likes_on_chinchin_id"
  add_index "likes", ["user_id"], :name => "index_likes_on_user_id"

  create_table "message_rooms", :force => true do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.string   "title"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "message_rooms", ["user1_id"], :name => "index_message_rooms_on_user1_id"
  add_index "message_rooms", ["user2_id"], :name => "index_message_rooms_on_user2_id"

  create_table "messages", :force => true do |t|
    t.integer  "message_room_id"
    t.integer  "writer_id"
    t.integer  "message_type"
    t.string   "content"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "messages", ["message_room_id"], :name => "index_messages_on_message_room_id"
  add_index "messages", ["writer_id"], :name => "index_messages_on_writer_id"

  create_table "profile_photos", :force => true do |t|
    t.integer  "chinchin_id"
    t.string   "picture_url"
    t.string   "source_url"
    t.integer  "facebook_likes"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "profile_photos", ["chinchin_id"], :name => "index_profile_photos_on_chinchin_id"
  add_index "profile_photos", ["picture_url"], :name => "index_profile_photos_on_picture_url"

  create_table "reports", :force => true do |t|
    t.string   "title"
    t.decimal  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "temp_chinchins", :force => true do |t|
    t.integer  "chinchin_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "birthday"
    t.string   "location"
    t.string   "hometown"
    t.string   "employer"
    t.string   "position"
    t.string   "gender"
    t.string   "relationship_status"
    t.string   "school"
    t.string   "locale"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "device_token"
    t.string   "apid"
    t.datetime "last_login"
    t.integer  "status",              :default => 0
    t.integer  "photo_count"
    t.text     "sorted_chinchin"
    t.text     "chosen_chinchin"
    t.string   "auth_token"
    t.string   "auth_secret"
    t.text     "bio"
    t.text     "quotes"
    t.datetime "registered_at"
    t.string   "username"
  end

  add_index "users", ["status"], :name => "index_users_on_status"
  add_index "users", ["uid"], :name => "index_users_on_uid"

  create_table "views", :force => true do |t|
    t.integer  "viewer_id"
    t.integer  "viewee_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "views", ["viewee_id"], :name => "index_views_on_viewee_id"
  add_index "views", ["viewer_id"], :name => "index_views_on_viewer_id"

end
