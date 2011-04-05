module Newscloud
  class SettingGroups

    def self.groups() @@groups end
    def self.group(name) self.groups[name] end
    def self.group_names() self.groups.keys end

    @@groups = {
      :some_group => {
        :title => "My Setting Group",
        :pages => [
          {
            :tab_title => "Initial Config",
            :page_title => "Initial Group Config Settings",
            :page_description => "This is the page description for this Initial Config page",
            :items => [
              {
                :title => "Item title",
                :required => true,
                :description => "Need an Item Title",
                :setting => ["site_title", nil],
                :hint => "Please add an Item Title"
              },
              {
                :title => "Item Description",
                :required => true,
                :description => "Need an Item Description",
                :setting => ["site_topic", nil],
                :hint => "Please add an Item Description"
              },
              {
                :title => "Item Description",
                :required => true,
                :description => "Need an Item Description",
                :setting => ["contact_us", nil],
                :hint => "Please add an Item Description"
              }
            ]
          },
          {
            :tab_title => "Seconday Config",
            :page_title => "Seconday Group Config Settings",
            :page_description => "This is the page description for this Seconday Config page",
            :items => [
              {
                :title => "Item title",
                :required => true,
                :description => "Need an Item Title",
                :setting => ["site_title", nil],
                :hint => "Please add an Item Title"
              },
              {
                :title => "Item Description",
                :required => true,
                :description => "Need an Item Description",
                :setting => ["site_topic", nil],
                :hint => "Please add an Item Description"
              },
              {
                :title => "Item Description",
                :required => true,
                :description => "Need an Item Description",
                :setting => ["contact_us", nil],
                :hint => "Please add an Item Description"
              }
            ]
          }
        ]
      }
    }

  end
end
