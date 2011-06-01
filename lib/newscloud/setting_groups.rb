module Newscloud
  class SettingGroups

    def self.groups() @@groups end
    def self.group(name) self.groups[name] end
    def self.group_names() self.groups.keys end

    #
    # Group Template
    #
    #:some_group => {
    #  :title       => "My Group",
    #  :description => "Description for My Group",
    #  :pages       => [
    #    {
    #      :tab_title        => "My Group Page 1",
    #      :page_title       => "First page of settings for my groupd",
    #      :page_description => "This is the page description",
    #      :items            => [
    #        {
    #          :title       => "Some Setting title",
    #          :required    => true,
    #          :description => "OPTIONAL:: This is the optional setting description",
    #          USE EITHER SETTING OR TRANSLATION
    #          :setting     => ["key_name", "key_sub_type" || nil], # Maps to Metadata::Setting.get_setting(key_name, key_sub_type)
    #          :translation => "some.locale.translation", # Maps to @locale.translations.find_by_raw_key("some.locale.translation")
    #          :hint        => "Hint for this setting."
    #        },
    #        ...
    #      ]
    #    },
    #    ...
    #  ]
    #}
    @@groups = {
      :basic_site_config => {
        # Complete when site_title, site_topic, contact_us, site_notification_user, app_id are configured
        :title       => "Initial Site Settings",
        :description => "This contains basic site settings like Site Title and Site Description, primary contact info, and your facebook application id.",
        :pages       => [
          {
            :tab_title        => "Site Description",
            :page_title       => "Site Title and Topic Configuration",
            :page_description => "Your site title and topic are used throughout the site to let users know who you are what your site is about.",
            :faq_url => nil,
            :items            => [
              {
                :title       => "Site Title",
                :required    => true,
                :description => nil,
                :setting     => ["site_title", nil],
                :hint        => "Please add a title for your site."
              },
              {
                :title       => "Site Topic",
                :required    => true,
                :description => nil,
                :setting     => ["site_topic", nil],
                :hint        => "Please add a topic description for your site."
              }
            ]
          },
          {
            :tab_title        => "Site Contact Information",
            :page_title       => "Primary Contact Settings",
            :page_description => "Settings for the primary Admin contact, and email addresses for where to forward user questions.",
            :faq_url => nil,
            :items            => [
              {
                :title       => "Contact Us Email addresses",
                :required    => true,
                :description => "Add the email addresses you would like messages to be forwarded too when a user posts a 'Contact Us' question.",
                :setting     => ["contact_us", nil],
                :hint        => "Comma separated list of email addresses."
              },
              {
                :title       => "Site Notification User",
                :required    => true,
                :description => "This is the user account that will be used to send dashboard messages, reminder emails, and other contact information.",
                :setting     => ["site_notification_user", nil],
                :hint        => "Please insert a user id."
              }
            ]
          },
          {
            :tab_title        => "Facebook Application ID",
            :page_title       => "Set your facebook application ID. This will configure the application Like badge in the footer.",
            :faq_url => "http://support.newscloud.com/kb/installing-newscloud/how-to-register-your-application-with-facebook",
            :items            => [
              {
                :title       => "Facebook application ID",
                :required    => true,
                :description => 'You can find your facebook application id at <a href="http://www.facebook.com/developers/apps.php" target="_ext">http://www.facebook.com/developers/apps.php</a>',
                :setting     => ["app_id", "facebook"],
              }
            ]
          }
        ]
      },
      :bitly_config => {
        # hide when bitly_username, bitly_api_key no longer defaulted as username and api_key
        :title => "Bit.ly URL Shortening Settings",
        :description => "Configuration settings for use with bit.ly in your application.",
        :faq_url => "http://support.newscloud.com/kb/configuring-your-application/how-to-configure-bitly-url-shortening",
        :pages => [
          {
            :tab_title        => "Bit.ly Config",
            :page_title       => "Set your username and API key here.",
            :page_description => %{Provide your username and API for your bit.ly account to use URL shortening in the app. If you do not have a bit.ly account, you can register by following the link: <a href="http://bit.ly/a/sign_up" target="_ext">http://bit.ly/a/sign_up</a>.},
            :items            => [
              {
                :title       => "Bit.ly username",
                :required    => true,
                :description => nil,
                :setting     => ["bitly_username", "bitly"],
                :hint        => "Please add your bit.ly username."
              },
              {
                :title       => "Bit.ly API KEY",
                :required    => true,
                :description => %{You can find you're bit.ly API key here: <a href="http://bit.ly/a/account" target="_ext">http://bit.ly/a/account</a>},
                :setting     => ["bitly_api_key", "bitly"],
                :hint        => "Please provide your bit.ly API key."
              }
            ]
          }
        ]
      },
      :analytics_config => {
        # hide when google_analytics_account_id is configured
        :title       => "Google Analytics Config",
        :description => "Configuration options for tracking user statistics with Google Analytics",
        :faq_url => "http://support.newscloud.com/kb/configuring-your-application/how-to-set-up-google-analytics-to-track-activity-on-your-site",
        :pages       => [
          {
            :tab_title        => "Google Analytics",
            :page_title       => "Google Analytics Config",
            :page_description => %{Set your Google Analyics Account Info. If you do not have a google analytics account yet, you can register by following the link: <a href="http://google.com/analytics" target="_ext">http://google.com/analytics</a>.},
            :items => [
              {
                :title       => "Google Analytics Account ID",
                :required    => true,
                :description => nil,
                :setting     => ["google_analytics_account_id", nil],
                :hint        => "Please add your google analytics account id."
              },
              {
                :title       => "Google Analytics Site ID",
                :required    => true,
                :description => nil,
                :setting     => ["google_analytics_site_id", nil],
                :hint        => "Please add your google analytics site id."
              }
            ]
          }
        ]
      },
      :sitemap_seo_config => {
        # hide when google-site-verification is configured
        # yahoo settings are optional
        :title       => "Search Engine Sitemap Configuration",
        :description => "Configuration options for SEO optimization with Google Sitemaps and Yahoo Sitemaps",
        :faq_url => "http://support.newscloud.com/kb/configuring-your-application/how-to-tell-search-engines-such-as-google-to-index-your-site",
        :pages       => [
          {
            :tab_title        => "Google Sitemap Configuration",
            :page_title       => "Configuration Settings for Google Sitemap",
            :page_description => %{Set your Google Sitemap Account Info. If you do not have a google sitemap account yet, you can register by following the link: <a href="https://www.google.com/webmasters/tools/home?hl=en" target="_ext">https://www.google.com/webmasters/tools/home?hl=en</a>.},
            :items            => [
              {
                :title       => "Google Sitemap Verification Key",
                :required    => true,
                :description => nil,
                :setting     => ["google-site-verification", nil],
                :hint        => "Please add your google sitemap verification key."
              }
            ]
          },
          {
            :tab_title        => "Yahoo Sitemap Configuration",
            :page_title       => "Configuration Settings for Yahoo Sitemap",
            :page_description => %{Set your Yahoo Sitemap Account Info. If you do not have a yahoo sitemap account yet, you can register by following the link: <a href="http://siteexplorer.search.yahoo.com/" target="_ext">http://siteexplorer.search.yahoo.com/http://siteexplorer.search.yahoo.com/</a>.},
            :items            => [
              {
                :title       => "Yahoo Sitemap Verification Key",
                :required    => true,
                :description => nil,
                :setting     => ["yahoo-site-verification", nil],
                :hint        => "Please add your yahoo sitemap verification key."
              },
              {
                :title       => "Yahoo Sitemap Application ID",
                :required    => true,
                :description => nil,
                :setting     => ["yahoo_app_id", nil],
                :hint        => "Please add your yahoo application ID."
              }
            ]
          }
        ]
      },
      :google_custom_search_engine_config => {
        # Hide when google_search_engine_id is configured
        :title       => "Google Custom Search Engine Config",
        :description => "Use this to setup a custom search engine with your app to allow users to more easily find content",
        :faq_url => "http://support.newscloud.com/kb/configuring-your-application/how-to-configure-google-search-in-your-navigation-bar",
        :pages       => [
          {
            :tab_title        => "Google CSE Config",
            :page_title       => "Configuration settings for Google Custom Search Engine",
            :page_description => %{Set your Google Custom Search Engine ID here to enable custom search powered by google on your application. If you do not have a google custom search engine account yet, you can register by following the link: <a href="http://www.google.com/cse/" target="_ext">http://www.google.com/cse/</a>.},
            :items            => [
              {
                :title       => "Google Custom Search Engine ID",
                :required    => true,
                :description => nil,
                :setting     => ["google_search_engine_id", nil],
                :hint        => "Please add your google search engine ID."
              }
            ]
          }
        ]
      },
      :welcome_panel_config => {
        # Hide when shared.sidebar.welcome_panel.welcome_panel_headline changed from "Welcome to our site"
        # and when shared.sidebar.welcome_panel.welcome_panel_message_fbml changed from "This is such a wonderful community to keep up on local events. We hope you enjoy yourself here."
        :title       => "Welcome Panel Text Configuration",
        :description => "Customize the headline and blurb that new users see in the welcome panel.",
        :faq_url => nil,
        :pages       => [
          {
            :tab_title        => "Welcome Panel Config",
            :page_title       => "Customize the text strings for the Welcome Panel",
            :page_description => %{Set the headline and blurb you want users to see in the welcome panel when they come to the site.},
            :items            => [
              {
                :title       => "Welcome Panel Headline",
                :required    => true,
                :description => nil,
                :translation => "shared.sidebar.welcome_panel.welcome_panel_headline",
                :hint        => "Set the welcome panel headline here."
              },
              {
                :title       => "Welcome Panel Blurb",
                :required    => true,
                :description => nil,
                :translation => "shared.sidebar.welcome_panel.welcome_panel_message_fbml",
                :hint        => "Set the welcome panel blurb here."
              }
            ]
          }
        ]
      }
    }

  end
end
