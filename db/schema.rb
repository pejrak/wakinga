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

ActiveRecord::Schema.define(:version => 20120607165559) do

  create_table "admins", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beads", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "beads_posts_count", :default => 0
    t.boolean  "parent_bead"
  end

  create_table "beads_interests", :force => true do |t|
    t.integer "interest_id"
    t.integer "bead_id"
  end

  create_table "beads_posts", :force => true do |t|
    t.integer "bead_id"
    t.integer "post_id"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "enrollments", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interests", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "i_seal",     :default => false
  end

  create_table "interests_posts", :force => true do |t|
    t.integer  "interest_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :primary_key => "language_id", :force => true do |t|
    t.string  "language_name",                                     :null => false
    t.string  "language_short",     :limit => 3
    t.string  "language_locale",    :limit => 10,                  :null => false
    t.boolean "language_extended",                                 :null => false
    t.integer "language_order",                   :default => 300, :null => false
    t.boolean "language_in_use"
    t.string  "language_continent", :limit => 0
  end

  create_table "memorizations", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "memorable"
    t.string   "status_indication"
    t.text     "change_record"
  end

  create_table "note", :primary_key => "note_id", :force => true do |t|
    t.integer   "message_value_fid", :null => false
    t.integer   "user_fid",          :null => false
    t.timestamp "note_date_created", :null => false
    t.text      "note_text",         :null => false
  end

  create_table "note_status", :primary_key => "note_status_id", :force => true do |t|
    t.integer "user_fid",                        :null => false
    t.integer "note_fid",                        :null => false
    t.string  "note_status_value", :limit => 32, :null => false
  end

  create_table "nouns", :force => true do |t|
    t.string   "title"
    t.boolean  "b_active"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment", :primary_key => "payment_id", :force => true do |t|
    t.integer  "user_fid",                                                            :null => false
    t.integer  "payment_variable_symbol",                                             :null => false
    t.datetime "payment_created_date",                                                :null => false
    t.datetime "payment_confirmed_date",                                              :null => false
    t.datetime "payment_start_date",                                                  :null => false
    t.datetime "payment_end_date",                                                    :null => false
    t.integer  "payment_days_duration",                                               :null => false
    t.decimal  "payment_price_with_vat",               :precision => 10, :scale => 0, :null => false
    t.decimal  "payment_price_no_vat",                 :precision => 10, :scale => 0, :null => false
    t.integer  "payment_vat",                                                         :null => false
    t.string   "payment_type",            :limit => 0,                                :null => false
  end

  create_table "phrases", :primary_key => "phrase_id", :force => true do |t|
    t.string  "phrase_tag", :null => false
    t.integer "project_id", :null => false
  end

  add_index "phrases", ["project_id"], :name => "fk_phrases_projects1"

  create_table "phrases_values", :primary_key => "phrase_value_id", :force => true do |t|
    t.integer "phrase_id",   :null => false
    t.integer "language_id", :null => false
    t.text    "value"
  end

  add_index "phrases_values", ["language_id"], :name => "fk_phrase_values_languages1"
  add_index "phrases_values", ["phrase_id"], :name => "fk_phrase_values_phrases1"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "rating"
    t.integer  "p_private",  :default => 0
  end

  create_table "projects", :primary_key => "project_id", :force => true do |t|
    t.integer   "user_id",                                 :null => false
    t.string    "project_name",                            :null => false
    t.timestamp "project_created_timestamp",               :null => false
    t.string    "project_secret"
    t.string    "project_key",                             :null => false
    t.string    "project_csv_delimiter",     :limit => 32
    t.string    "project_csv_eol",           :limit => 32
  end

  add_index "projects", ["user_id"], :name => "fk_projects_users1"

  create_table "projects_languages", :id => false, :force => true do |t|
    t.integer "project_id",    :null => false
    t.integer "language_id",   :null => false
    t.boolean "main_language"
  end

  add_index "projects_languages", ["language_id"], :name => "fk_projects_has_languages_languages1"

  create_table "requests", :force => true do |t|
    t.string   "r_type"
    t.string   "r_title"
    t.text     "r_description"
    t.string   "r_priority"
    t.string   "r_status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trusts", :force => true do |t|
    t.integer  "trustee_id"
    t.integer  "interest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trustor_id"
  end

  create_table "user_interest_preferences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "interest_id"
    t.datetime "last_visit_at"
    t.boolean  "i_private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_preferences", :force => true do |t|
    t.string   "subscription_preference"
    t.integer  "messages_per_page"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                              :null => false
    t.string   "encrypted_password",   :limit => 128,                :null => false
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
    t.string   "username"
    t.string   "avatar"
    t.string   "role"
    t.string   "authentication_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
