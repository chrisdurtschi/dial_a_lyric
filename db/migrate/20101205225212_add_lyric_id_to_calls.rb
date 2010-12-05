class AddLyricIdToCalls < ActiveRecord::Migration
  def self.up
    remove_column :calls, :lyric_url
    add_column :calls, :lyric_id, :integer
  end

  def self.down
    add_column :calls, :lyric_url, :string
    remove_column :calls, :lyric_id
  end
end
