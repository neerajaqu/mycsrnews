namespace :n2 do

  namespace :widgets do
    desc "Build widgets from your widget.yml file"
    task :build => :environment do
      widget_data = load_widgets
      raise "Widgets file not found at config/widgets.yml" unless widget_data

      existing_widgets = Widget.all
      widget_data.each do |type, widgets|
        puts "Creating #{type} widgets."
        widgets.each do |name, fields|
          if widget_exists? name
          	puts "\tWidget #{name} exists, skipping..."
          	next
          end
          puts "\tBuilding #{name} widget."

          data = {:content_type => type}
          data[:name] = name

          fields.each do |field, value|
            data[field] = value
          end

          Widget.create(data)
        end
      end
    end

    desc "Deletes and rebuilds all widgets"
    task :rebuild => :environment do
      Widget.destroy_all
      WidgetPage.destroy_all
      Rake::Task['n2:widgets:build'].invoke
    end

    desc "Only adds in new widgets"
    task :update => :environment do
      Rake::Task['n2:widgets:build'].invoke
    end
  end

end

def load_widgets
  return false unless FileTest.exists?("#{RAILS_ROOT}/config/widgets.yml")
  YAML.load_file("#{RAILS_ROOT}/config/widgets.yml")['widgets']
end

def widget_exists? widget_name
  ! Widget.find_by_name(widget_name).nil?
end
