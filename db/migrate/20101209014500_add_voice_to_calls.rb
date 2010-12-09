class AddVoiceToCalls < ActiveRecord::Migration
  def self.up
    add_column :calls, :voice, :string, :default => 'allison'
  end

  def self.down
    remove_column :calls, :voice
  end
end
