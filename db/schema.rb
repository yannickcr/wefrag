# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081226115548) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.integer  "position",   :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", :force => true do |t|
    t.integer  "category_id",                   :null => false
    t.integer  "position",       :default => 1, :null => false
    t.string   "title",                         :null => false
    t.string   "stripped_title",                :null => false
    t.text     "description",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forums", ["stripped_title"], :name => "index_forums_on_stripped_title", :unique => true

  create_table "group_forum_rights", :force => true do |t|
    t.integer  "group_id",                             :null => false
    t.integer  "forum_id",                             :null => false
    t.boolean  "is_read",           :default => true,  :null => false
    t.boolean  "is_post",           :default => true,  :null => false
    t.boolean  "is_reply",          :default => true,  :null => false
    t.boolean  "is_edit",           :default => true,  :null => false
    t.boolean  "is_moderate",       :default => false, :null => false
    t.boolean  "is_topic_moderate", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_forum_rights", ["group_id", "forum_id"], :name => "index_group_forum_rights_on_group_id_and_forum_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "height"
    t.integer  "width"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imported_nofrag_items", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "remote_id"
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imported_nofrag_items", ["remote_id"], :name => "index_imported_nofrag_items_on_remote_id", :unique => true

  create_table "open_id_associations", :force => true do |t|
    t.binary  "server_url", :null => false
    t.string  "handle",     :null => false
    t.binary  "secret",     :null => false
    t.integer "issued",     :null => false
    t.integer "lifetime",   :null => false
    t.string  "assoc_type", :null => false
  end

  create_table "open_id_nonces", :force => true do |t|
    t.string  "server_url", :null => false
    t.integer "timestamp",  :null => false
    t.string  "salt",       :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "forum_id",                         :null => false
    t.integer  "topic_id"
    t.integer  "user_id",                          :null => false
    t.string   "ip_address",                       :null => false
    t.string   "title",         :default => "",    :null => false
    t.text     "body",                             :null => false
    t.boolean  "is_locked",     :default => false, :null => false
    t.boolean  "is_sticky",     :default => false, :null => false
    t.integer  "posts_count",   :default => 0,     :null => false
    t.datetime "edited_at"
    t.datetime "last_post_at"
    t.integer  "last_reply_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["forum_id", "topic_id", "is_sticky", "last_post_at"], :name => "index_topics_list"
  add_index "posts", ["updated_at"], :name => "index_posts_on_updated_at"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shouts", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "ip_address"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shouts", ["created_at"], :name => "index_shouts_on_created_at"

  create_table "user_infos", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.string   "steam_id"
    t.string   "xboxlive_id"
    t.string   "psn_id"
    t.string   "job"
    t.string   "website"
    t.boolean  "is_email",    :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_infos", ["user_id"], :name => "index_user_infos_on_user_id", :unique => true

  create_table "user_openid_trusts", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "trust_root"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_openid_trusts", ["user_id", "trust_root"], :name => "index_user_openid_trusts_on_user_id_and_trust_root"

  create_table "user_topic_infos", :force => true do |t|
    t.integer  "user_id",                      :null => false
    t.integer  "topic_id",                     :null => false
    t.boolean  "is_reply",   :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_topic_infos", ["user_id", "topic_id"], :name => "index_user_topic_infos_on_user_id_and_topic_id", :unique => true

  create_table "user_topic_reads", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "topic_id",                      :null => false
    t.datetime "read_at"
    t.boolean  "is_forever", :default => false
  end

  add_index "user_topic_reads", ["user_id", "topic_id"], :name => "index_user_topic_reads_on_user_id_and_topic_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                                                                                                                                   :null => false
    t.string   "email",                                                                                                                                   :null => false
    t.integer  "group_id"
    t.boolean  "is_admin",                                                                                                          :default => false,    :null => false
    t.string   "crypted_password",  :limit => 40
    t.string   "salt",              :limit => 40
    t.string   "confirmation_code", :limit => 40
    t.string   "first_name",                                                                                                        :default => ""
    t.string   "last_name",                                                                                                         :default => ""
    t.string   "city",                                                                                                              :default => ""
    t.string   "country",                                                                                                           :default => ""
    t.date     "birthdate"
    t.enum     "gender",            :limit => [:male, :female],                                                                     :default => :male
    t.enum     "state",             :limit => [:passive, :pending, :notified, :confirmed, :accepted, :refused, :active, :disabled], :default => :passive, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_id"
  end

  add_index "users", ["confirmation_code"], :name => "index_users_on_confirmation_code"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
