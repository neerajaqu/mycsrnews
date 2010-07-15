class DropLegacySourceFromContent < ActiveRecord::Migration
  def self.up
    remove_column :contents, :source
  end

  def self.down
  end
end
