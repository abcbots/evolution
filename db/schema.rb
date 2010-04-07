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

ActiveRecord::Schema.define(:version => 20100407041630) do

  create_table "evolution_priorities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "evolution_id"
    t.integer  "mutation_id"
    t.integer  "prioritization"
    t.integer  "ancestorization"
  end

  create_table "evolutions", :force => true do |t|
    t.integer  "evolution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time"
    t.string   "header"
    t.text     "detail"
    t.boolean  "show_formatting"
    t.integer  "ancestor_size"
    t.integer  "ancestorization"
    t.integer  "prioritization"
    t.boolean  "childless"
    t.integer  "feature_id"
  end

  create_table "features", :force => true do |t|
    t.integer  "evolution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mutations", :force => true do |t|
    t.integer  "mutation_id"
    t.integer  "evolution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
  end

end
