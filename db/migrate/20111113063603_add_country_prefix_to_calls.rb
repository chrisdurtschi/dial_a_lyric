class AddCountryPrefixToCalls < ActiveRecord::Migration
  def self.up
    add_column :calls, :from_number_country_prefix, :string
    add_column :calls, :to_number_country_prefix, :string
  end

  def self.down
    remove_column :calls, :to_number_country_prefix
    remove_column :calls, :from_number_country_prefix
  end
end
