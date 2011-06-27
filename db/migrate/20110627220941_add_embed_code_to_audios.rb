class AddEmbedCodeToAudios < ActiveRecord::Migration
  def self.up
    add_column :audios, :embed_code, :text
  end

  def self.down
    remove_column :audios, :embed_code
  end
end
