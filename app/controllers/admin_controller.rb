class AdminController < ApplicationController
  layout proc {|c| c.request.xhr? ? false : "new_admin" }

  before_filter :check_admin_or_default_status
  before_filter :set_current_tab
  before_filter :check_iframe

  self.class_eval do
    def self.foo() raise @config.inspect end
    # TODO::
    #   - finish methods
    #   - add associations to edit/new forms
    #   - dynamically find associations 
    #   - add association lists to show page
    #   - add mixin logic
    #   - add action links
    #   - only show new links if actions.include? :new
    #   - add related links
    #   - add return links
    #   - switch to allowing model_id or hash options
    def self.admin_scaffold_build_config model_id = nil
      # switch to calling methods in context of admin_scaffold_config object
      @config = OpenStruct.new
      @config.model_id = model_id
      @config.klass_name = self.to_s.split('::').last.sub(/Controller$/, '')
      @config.model_klass = @config.model_id.to_s.classify.constantize
      @config.actions = [:index, :show, :new, :create, :edit, :update, :destroy]
      @config.fields = @config.model_klass.columns
      @config.paginate = true
      @config.associations = {}
      @config.edit_fields = @config.fields.select {|f| not (f.name =~ /_at$/ or f.name == 'id' or f.name =~ /tally|count$/) }
      @config
    end

    def self.admin_scaffold(model_id = nil, &block)
      raise ArgumentError.new("Must provide model_id or config block") unless model_id.present? or block_given?

      cattr_accessor :admin_scaffold_config
      self.admin_scaffold_build_config model_id

      yield @config if block_given?

      @config.actions.each do |action|
        define_method action do
          case action
          when :index
            @config = self.admin_scaffold_config
            render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
              :items => @config.model_klass.active.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
              :model => @config.model_klass,
              :fields => @config.index_fields || @config.fields.map(&:name),
              :associations => @config.associations,
              :paginate => @config.paginate
            }
          when :show
            @config = self.admin_scaffold_config
            render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
              :item => @config.model_klass.find(params[:id]),
              :model => @config.model_klass,
              :associations => @config.associations,
              :fields => @config.show_fields || @config.fields.map(&:name),
            }
          when :edit
            @config = self.admin_scaffold_config
            render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
              :item => @config.model_klass.find(params[:id]),
              :model => @config.model_klass,
              :associations => @config.associations,
              :fields => @config.edit_fields.map(&:name),
            }
          else
          	render :text => "Implement: #{action}", :layout => 'new_admin'
          end
        end
      end

      self.admin_scaffold_config = @config
    end

    def self.admin_action
      raise self.action_name.inspect
    end
  end

  def index
    # Loads dashboard
    # TODO:: make the dashboard actually a dashboard
    #redirect_to admin_contents_path
  end

  private

  def set_current_tab
    @current_tab = 'dashboard'
  end

  def check_admin_or_default_status
    return true if current_user and current_user.is_admin?

    if User.admins.empty?
      authenticate_or_request_with_http_basic do |username, password|
        username == APP_CONFIG['default_admin_user'] and password == APP_CONFIG['default_admin_password']
      end
    else 
      redirect_to home_index_path and return false
    end
  end

  def find_moderatable_item
    params.each do |name, value|
      next if name =~ /^fb/
      if name =~ /(.+)_id$/
        # switch story requests to use the content model
        klass = $1 == 'story' ? 'content' : $1
        return klass.classify.constantize.find(value)
      end
    end
    nil
  end

  def check_iframe
    if @iframe_status
    	@iframe_status = false
    	redirect_to admin_path and return false
    end
  end

end
