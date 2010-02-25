class UpdateFeedsTable < ActiveRecord::Migration
  def self.up
    # HACKETY HACK:: we need to use an intermediary table name because of case sensitivity issues
    # with mysql on different platorms......... sweet.
    rename_table  :Feeds,     :tmp_feeds
    rename_table  :tmp_feeds, :feeds
    add_column :feeds, :created_at, :datetime
    add_column :feeds, :updated_at, :datetime
    rename_column :feeds, :lastFetch, :last_fetched_at
    rename_column :feeds, :userid, :user_id
    change_column :feeds, :feedType, :string
    change_column :feeds, :specialType, :string
    change_column :feeds, :loadOptions, :string
  end

  def self.down
  end
end
