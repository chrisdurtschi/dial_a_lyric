class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.string :name
      t.string :number
      t.string :lyric_url

      t.timestamps
    end
  end

  def self.down
    drop_table :calls
  end
end
