module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    when /the new idea_board page/
      new_idea_board_path

    when /the new idea page/
      new_idea_path

    when /the new story page/
      new_story_path

    when /the new session page/
      new_session_path

    when /the new resource page/
      new_resource_path

    when /the new newswire page/
      new_newswire_path

    when /the new home page/
      new_home_path

    when /the new comment page/
      new_comment_path

    when /the new related_item page/
      new_related_item_path

    when /the new article page/
      new_article_path

    when /the new article page/
      new_article_path

    when /the new article page/
      new_article_path

    when /the new frooble page/
      new_frooble_path

    when /the new test page/
      new_test_path

    
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
