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

ActiveRecord::Schema.define(:version => 20111113063603) do

  create_table "calls", :force => true do |t|
    t.string   "to_name"
    t.string   "to_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lyric_id"
    t.string   "from_name"
    t.string   "from_number"
    t.string   "voice",                      :default => "allison"
    t.string   "from_number_country_prefix"
    t.string   "to_number_country_prefix"
  end

  create_table "lyrics", :force => true do |t|
    t.string   "url"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "artist"
    t.string   "album"
  end

end
