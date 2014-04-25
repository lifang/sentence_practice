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

ActiveRecord::Schema.define(:version => 20140424024544) do

  create_table "answer_details", :force => true do |t|
    t.integer  "question_id"
    t.integer  "answer_times"
    t.integer  "correct_times"
    t.integer  "user_id"
    t.boolean  "first_status",  :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "second_status", :default => false
  end

  add_index "answer_details", ["question_id"], :name => "index_answer_details_on_question_id"
  add_index "answer_details", ["user_id"], :name => "index_answer_details_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer  "level_types"
    t.string   "translation"
    t.string   "original_sentence"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "similar_words"
  end

  add_index "questions", ["level_types"], :name => "index_questions_on_level_types"

  create_table "share_records", :force => true do |t|
    t.integer  "user_id"
    t.string   "open_id"
    t.boolean  "status",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "share_records", ["user_id"], :name => "index_share_records_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "uniq_id"
    t.integer  "level"
    t.integer  "complete_per_cent"
    t.integer  "gold"
    t.string   "open_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
