class ChangeFeedsLastFetchDefault < ActiveRecord::Migration
  def self.up
    change_column :feeds, :last_fetched_at, :datetime, :null => true, :default => nil
  end

  def self.down
  end
end
