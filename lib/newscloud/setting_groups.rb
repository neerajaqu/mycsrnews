module Newscloud
  class SettingGroups

    def self.groups() @@groups end
    def self.group(name) self.groups[name] end
    def self.group_names() self.groups.keys end

    #
    # Group Template
    #
    #:some_group => {
    #  :title => "My Group",
    #  :pages => [
    #    {
    #      :tab_title => "My Group Page 1",
    #      :page_title => "First page of settings for my groupd",
    #      :page_description => "This is the page description",
    #      :items => [
    #        {
    #          :title => "Some Setting title",
    #          :required => true,
    #          :description => "OPTIONAL:: This is the optional setting description",
    #          :setting => ["key_name", "key_sub_type" || nil], # Maps to Metadata::Setting.get_setting(key_name, key_sub_type)
    #          :hint => "Hint for this setting."
    #        },
    #        ...
    #      ]
    #    },
    #    ...
    #  ]
    #}
    @@groups = {
      :basic_site_config => {
        :title => "Initial Site Configuration Settings",
        :pages => [
          {
            :tab_title => "Site Description",
            :page_title => "Site Title and Topic Configuration",
            :page_description => "Your site title and topic are used throughout the site to let users know who you are what your site is about.",
            :items => [
              {
                :title => "Site Title",
                :required => true,
                :description => nil,
                :setting => ["site_title", nil],
                :hint => "Please add a title for your site."
              },
              {
                :title => "Site Topic",
                :required => true,
                :description => nil,
                :setting => ["site_topic", nil],
                :hint => "Please add a topic description for your site."
              }
            ]
          },
          {
            :tab_title => "Admin Contact Info",
            :page_title => "Primary Contact Settings",
            :page_description => "Settings for the primary Admin contact, and email addresses for where to forward user questions.",
            :items => [
              {
                :title => "Contact Us Email addresses",
                :required => true,
                :description => "Add the email addresses you would like messages to be forwarded too when a user posts a 'Contact Us' question.",
                :setting => ["contact_us", nil],
                :hint => "Comma separated list of email addresses."
              },
              {
                :title => "Site Notification User",
                :required => true,
                :description => "This is the user account that will be used to send dashboard messages, reminder emails, and other contact information.",
                :setting => ["site_notification_user", nil],
                :hint => "Please insert a user id."
              }
            ]
          }
        ]
      },
      :bitly_config => {
        :title => "Bit.ly URL Shortening Settings",
        :pages => [
          {
            :tab_title => "Bit.ly Config",
            :page_title => "Set your username and API key here.",
            :page_description => %{Provide your username and API for your bit.ly account to use URL shortening in the app. If you do not have a bit.ly account, you can register by following the link: <a href="http://bit.ly/a/sign_up" target="_ext">http://bit.ly/a/sign_up</a>.},
            :items => [
              {
                :title => "Bit.ly username",
                :required => true,
                :description => nil,
                :setting => ["bitly_username", "bitly"],
                :hint => "Please add your bit.ly username."
              },
              {
                :title => "Bit.ly API KEY",
                :required => true,
                :description => %{You can find you're bit.ly API key here: <a href="http://bit.ly/a/account" target="_ext">http://bit.ly/a/account</a>},
                :setting => ["bitly_api_key", "bitly"],
                :hint => "Please provide your bit.ly API key."
              }
            ]
          }
        ]
      },
      :analytics_config => {
        :title => "Google Analytics Config",
        :pages => [
          {
            :tab_title => "Google Analytics",
            :page_title => "Google Analytics Config",
            :page_description => %{Set your Google Analyics Account Info. If you do not have a google analytics account yet, you can register by following the link: <a href="http://google.com/analytics" target="_ext">http://google.com/analytics</a>.},
            :items => [
              {
                :title => "Google Analytics Account ID",
                :required => true,
                :description => nil,
                :setting => ["google_analytics_account_id", nil],
                :hint => "Please add your google analytics account id."
              },
              {
                :title => "Google Analytics Site ID",
                :required => true,
                :description => nil,
                :setting => ["google_analytics_site_id", nil],
                :hint => "Please add your google analytics site id."
              }
            ]
          }
        ]
      },
      :sitemap_seo_config => {
        :title => "Google and Yahoo Sitemap SEO Config",
        :pages => [
          {
            :tab_title => "Google Sitemap Config",
            :page_title => "Config Settings for Google Sitemap",
            :page_description => %{Set your Google Sitemap Account Info. If you do not have a google sitemap account yet, you can register by following the link: <a href="https://www.google.com/webmasters/tools/home?hl=en" target="_ext">https://www.google.com/webmasters/tools/home?hl=en</a>.},
            :items => [
              {
                :title => "Google Sitemap Verification Key",
                :required => true,
                :description => nil,
                :setting => ["google-site-verification", nil],
                :hint => "Please add your google sitemap verification key."
              }
            ]
          },
          {
            :tab_title => "Yahoo Sitemap Config",
            :page_title => "Config Settings for Yahoo Sitemap",
            :page_description => %{Set your Yahoo Sitemap Account Info. If you do not have a yahoo sitemap account yet, you can register by following the link: <a href="http://siteexplorer.search.yahoo.com/" target="_ext">http://siteexplorer.search.yahoo.com/http://siteexplorer.search.yahoo.com/</a>.},
            :items => [
              {
                :title => "Yahoo Sitemap Verification Key",
                :required => true,
                :description => nil,
                :setting => ["yahoo-site-verification", nil],
                :hint => "Please add your yahoo sitemap verification key."
              },
              {
                :title => "Yahoo Sitemap Application ID",
                :required => true,
                :description => nil,
                :setting => ["yahoo_app_id", nil],
                :hint => "Please add your yahoo application ID."
              }
            ]
          }
        ]
      },
      :google_custom_search_engine_config => {
        :title => "Google Custom Search Engine Config",
        :pages => [
          {
            :tab_title => "Google CSE Config",
            :page_title => "Config Settings for Google Custom Search Engine",
            :page_description => %{Set your Google Custom Search Engine ID here to enable custom search powered by google on your application. If you do not have a google custom search engine account yet, you can register by following the link: <a href="http://www.google.com/cse/" target="_ext">http://www.google.com/cse/</a>.},
            :items => [
              {
                :title => "Google Custom Search Engine ID",
                :required => true,
                :description => nil,
                :setting => ["google_search_engine_id", nil],
                :hint => "Please add your google search engine ID."
              }
            ]
          }
        ]
      }
    }

  end
end
