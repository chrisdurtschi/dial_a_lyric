class AddDetailsToLyrics < ActiveRecord::Migration
  def self.up
    add_column :lyrics, :title, :string
    add_column :lyrics, :artist, :string
    add_column :lyrics, :album, :string
  end

  def self.down
    remove_column :lyrics, :album
    remove_column :lyrics, :artist
    remove_column :lyrics, :title
  end
end
