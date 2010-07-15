class CreateChirpTable < ActiveRecord::Migration
  def self.up
    create_table :chirps do |t|
      t.integer   :user_id
      t.integer   :recipient_id
      t.string    :subject
      t.text      :message, :limit => 1000
      t.timestamps
    end
  end

  def self.down
    drop_table :chirps
  end
end
