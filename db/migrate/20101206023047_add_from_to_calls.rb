class AddFromToCalls < ActiveRecord::Migration
  def self.up
    add_column :calls, :from_name, :string
    add_column :calls, :from_number, :string
    rename_column :calls, :name, :to_name
    rename_column :calls, :number, :to_number
  end

  def self.down
    remove_column :calls, :from_number
    remove_column :calls, :from_name
    rename_column :calls, :to_name, :name
    rename_column :calls, :to_number, :number
  end
end
