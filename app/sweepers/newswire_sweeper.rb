class NewswireSweeper < ActionController::Caching::Sweeper

  def self.expire_newswires
    puts "Sweeping newswires"
    controller = ActionController::Base.new
    ['newswires_list'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
      controller.expire_fragment "#{fragment}_fbml"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "newswires_list_#{page}html"
      controller.expire_fragment "newswires_list_#{page}fbml"
    end
  end

end
