class CardSweeper < ActionController::Caching::Sweeper
  observe Card

  def after_save(card)
    clear_card_cache(card)
  end

  def after_destroy(card)
    clear_card_cache(card)
  end

  def clear_card_cache(card)
    ['top_sent_cards', 'newest_sent_cards', 'cards_list', card.cache_key].each do |fragment|
      expire_fragment "#{fragment}_html"
    end
  end

  def self.expire_card_all card
    controller = ActionController::Base.new
    ['top_sent_cards', 'newest_sent_cards', 'cards_list', card.cache_key].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
  end

end
