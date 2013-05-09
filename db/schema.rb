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

ActiveRecord::Schema.define(:version => 20130509162244) do

  create_table "queries", :force => true do |t|
    t.string   "query"
    t.string   "user_ids"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "queries", ["query"], :name => "index_queries_on_query", :unique => true

  create_table "records", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "bool"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "records", ["user_id"], :name => "index_records_on_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "about_me"
    t.string   "location"
    t.string   "website_url"
    t.string   "reputation"
    t.string   "skills"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "site_id"
    t.string   "profile_image"
    t.integer  "up_votes"
    t.integer  "down_votes"
    t.string   "badges"
    t.string   "question"
    t.string   "answer"
  end

  add_index "users", ["site_id"], :name => "index_users_on_site_id", :unique => true

end
