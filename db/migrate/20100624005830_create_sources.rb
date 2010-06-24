class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :name
      t.string :url
      t.boolean    :all_subdomains_valid, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
