module Newscloud
  module Acts
    module Scorable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_scorable
          has_many :user_scores, :as => :scorable

          after_create :async_score_later

          include Newscloud::Acts::Scorable::InstanceMethods
          extend Newscloud::Acts::Scorable::ClassMethods
        end
      end

      module InstanceMethods

        def scorable?
          true
        end

        def scorable_user
          user
        end

        def async_score_later
          Resque.enqueue(ScoreWorker, self.class.name, self.id, scorable_user.id)
        end

        def add_score(user_id)
          Score.create!({
          	:scorable   => self,
          	:user_id    => user_id,
          	:value      => self.get_model_score_value,
          	:score_type => self.get_model_score_type
          })
        end

        def get_model_score_value
          get_model_score.score_value
        end

        def get_model_score_type
          get_model_score.score_type
        end

        def get_model_score
          @model_score ||= Metadata::ActivityScore.find_activity_score(model_score_name)
        end

        def model_score_name
          self.class.name.underscore
        end

      end

      module ClassMethods

      end
    end
  end
end
