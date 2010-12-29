class Admin::PredictionScoresController < AdminController

  def refresh_all
    PredictionScore.refresh_all_scores
  end
  
end
