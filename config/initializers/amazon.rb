require 'amazon/ecs'

Amazon::Ecs.options = {:aWS_access_key_id => APP_CONFIG['amazon_aws_access_key_id'], :aWS_secret_key => APP_CONFIG['amazon_aws_secret_key'], :response_group => "Large"}
