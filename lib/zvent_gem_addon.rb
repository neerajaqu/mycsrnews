require 'zvent'
module Zvent
  # A zvent session used to search and everything
  class Session < Base
    def find_events_by_date(date, zvent_options = {}, options = {})      
      #location is required
      raise Zvent::NoLocationError.new if !date || date.strip.empty?
      
      #grab the json from zvents
      json_ret = get_resources(@base_url+"/search?#{zvent_options.merge(:when => date).merge(ZVENTS_DEFAULT_ARGUMENTS).to_query}")
      
      #return the json or objectified json
      options[:as_json] ? json_ret : objectify_zvents_json(json_ret)
    end
  end
  
end