class ConvertOrCreateCards < ActiveRecord::Migration
  def self.up
    if self.table_exists? "Cards"
    	rename_table  :Cards,      :tmp_cards
    	rename_table  :tmp_cards,  :cards
    	rename_column :cards, :shortCaption, :short_caption
    	rename_column :cards, :longCaption, :long_caption
    	rename_column :cards, :notSendable, :not_sendable
    	rename_column :cards, :isFeatured, :is_featured
    	change_column :cards, :is_featured, :boolean, :default => false
    	rename_column :cards, :dateCreated, :created_at
    	rename_column :cards, :dateAvailable, :available_at
    	add_column    :cards, :updated_at, :datetime
    	rename_column :cards, :slug, :slug_name
    	add_column    :cards, :sent_count, :integer, :default => 0
    else
      create_table :cards do |t|
        t.string    :name
        t.string    :short_caption
        t.text      :long_caption
        t.integer   :points, :default => 0
        t.string    :slug_name
        t.boolean   :not_sendable, :default => false
        t.boolean   :is_featured, :default => false
        t.datetime  :updated_at
        t.integer   :sent_count, :default => 0

        t.timestamps
      end
    end
  end

  def self.down
  end

  def self.table_exists? table_name
    begin
      ActiveRecord::Base.connection.execute "SELECT 1 FROM #{table_name}"
      return true
    rescue
      return false
    end
  end

end
