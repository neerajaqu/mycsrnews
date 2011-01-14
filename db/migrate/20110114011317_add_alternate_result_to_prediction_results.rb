class AddAlternateResultToPredictionResults < ActiveRecord::Migration
  def self.up
    add_column :prediction_results, :alternate_result, :string
  end

  def self.down
    remove_column :prediction_results, :alternate_result
  end
end
