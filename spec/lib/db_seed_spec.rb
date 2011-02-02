require "spec_helper"
require "rake"

describe "DB Seeds" do
  before do
    #@rake = Rake::Application.new
    #Rake.application = @rake
    #Rake.application.rake_require File.expand_path(File.join(File.dirname(__FILE__),'..','..','vendor','rails','railties','lib','tasks','databases.rake')).sub(/\.rake$/,'')
    #Rake::Task.define_task(:environment)
  end

  it "should run successfully once" do
    pending("Get rake db:seed task working from rspec")
    #expect { Metadata.destroy_all }.to change(Metadata, :count).to(0)
    Metadata.destroy_all
    Metadata.count.should == 0
    #expect { @rake['db:seed'].invoke }.to change(Metadata, :count)
    expect { `RAILS_ENV=test bundle exec rake db:seed`}.to change(Metadata, :count)
  end
end
