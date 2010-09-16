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

ActiveRecord::Schema.define(:version => 20100916103624) do

  create_table "activities", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "song_id"
    t.integer  "admin_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_messages", :force => true do |t|
    t.string "title"
    t.text   "body"
  end

  create_table "adyen_notifications", :force => true do |t|
    t.boolean  "live",                                                             :default => false, :null => false
    t.string   "event_code",                                                                          :null => false
    t.string   "psp_reference",                                                                       :null => false
    t.string   "original_reference"
    t.string   "merchant_reference",                                                                  :null => false
    t.string   "merchant_account_code",                                                               :null => false
    t.datetime "event_date",                                                                          :null => false
    t.boolean  "success",                                                          :default => false, :null => false
    t.string   "payment_method"
    t.string   "operations"
    t.text     "reason"
    t.string   "currency",              :limit => 3,                                                  :null => false
    t.decimal  "value",                              :precision => 9, :scale => 2
    t.boolean  "processed",                                                        :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adyen_notifications", ["psp_reference", "event_code", "success"], :name => "adyen_notification_uniqueness", :unique => true

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.boolean  "active",          :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_title"
  end

  create_table "payments", :force => true do |t|
    t.integer  "amount"
    t.string   "currency_code"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer "song_id"
    t.integer "value"
  end

  create_table "record_labels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", :force => true do |t|
    t.string   "title"
    t.integer  "album_id"
    t.integer  "user_id"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "mixdown_file_name"
    t.string   "mixdown_content_type"
    t.integer  "mixdown_content_file_size"
    t.integer  "samples"
  end

  create_table "tracks", :force => true do |t|
    t.string   "title"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sound_updated_at"
    t.integer  "user_id"
    t.string   "uploaded_data_file_name"
    t.string   "uploaded_data_content_type"
    t.integer  "uploaded_data_file_size"
    t.string   "mp3_file_name"
    t.string   "mp3_content_type"
    t.integer  "mp3_file_size"
    t.string   "wav_file_name"
    t.string   "wav_content_type"
    t.integer  "wav_file_size"
    t.string   "waveform_file_name"
    t.string   "waveform_content_type"
    t.integer  "waveform_content_file_size"
  end

  create_table "user_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "name"
    t.integer  "record_label_id"
    t.string   "website"
    t.text     "description"
    t.integer  "picture_id"
    t.integer  "user_type_id"
    t.boolean  "funky"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_users", :id => false, :force => true do |t|
    t.integer  "fan_id"
    t.integer  "idol_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
