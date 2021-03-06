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

ActiveRecord::Schema.define(:version => 20130517081225) do

  create_table "final_tags", :force => true do |t|
    t.string   "tag"
    t.text     "synonyms"
    t.text     "super"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "final_tags", ["tag"], :name => "index_final_tags_on_tag", :unique => true

  create_table "max_score_data", :force => true do |t|
    t.string   "skill"
    t.integer  "score"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "max_score_data", ["skill"], :name => "index_max_score_data_on_skill", :unique => true

  create_table "modified_with_syns", :force => true do |t|
    t.text     "tag"
    t.text     "extra"
    t.text     "synonyms"
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  create_table "modified_without_syns", :force => true do |t|
    t.text     "Tag"
    t.text     "extra"
    t.datetime "created_at",  :null => false
    t.datetime "modified_at", :null => false
  end

  create_table "queries", :force => true do |t|
    t.string   "query"
    t.text     "user_ids",   :limit => 255
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "queries", ["query"], :name => "index_queries_on_query", :unique => true

  create_table "records", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "bool"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "records", ["user_id"], :name => "index_records_on_user_id", :unique => true

  create_table "removed_tags", :force => true do |t|
    t.string   "tag"
    t.text     "synonyms"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tag_with_syns", :force => true do |t|
    t.string   "tag"
    t.text     "synonyms"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tag_with_syns", ["tag"], :name => "index_tag_with_syns_on_tag", :unique => true

  create_table "tag_without_syns", :force => true do |t|
    t.string   "tag"
    t.text     "synonyms"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tag_without_syns", ["tag"], :name => "index_tag_without_syns_on_tag", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "tag"
    t.text     "synonyms"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tags", ["tag"], :name => "index_tags_on_tag", :unique => true

  create_table "user_data", :force => true do |t|
    t.integer  "page"
    t.text     "user"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "reputation"
    t.integer  "user_id"
    t.text     "tagwise_score"
    t.float    "value"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.text     "about_me",      :limit => 255
    t.string   "location"
    t.string   "website_url"
    t.string   "reputation"
    t.string   "skills"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "site_id"
    t.string   "profile_image"
    t.integer  "up_votes"
    t.integer  "down_votes"
    t.string   "badges"
    t.text     "question",      :limit => 255
    t.text     "answer",        :limit => 255
    t.text     "tagwise_score"
    t.text     "raw_score"
  end

  add_index "users", ["site_id"], :name => "index_users_on_site_id", :unique => true

end
