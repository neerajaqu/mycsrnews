class Admin::LocalesController < AdminController
  # GET /locales
  # GET /locales.xml
  def index
    @locales = Locale.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locales }
    end
  end

  # GET /locales/1
  # GET /locales/1.xml
  def show
    @locale = Locale.find_by_code(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @locale }
    end
  end

  # GET /locales/new
  # GET /locales/new.xml
  def new
    @locale = Locale.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @locale }
    end
  end

  # GET /locales/1/edit
  def edit
    @locale = Locale.find_by_code(params[:id])
  end

  # POST /locales
  # POST /locales.xml
  def create
    @locale = Locale.new(params[:locale_form])

    respond_to do |format|
      if @locale.save
        flash[:notice] = 'Locale was successfully created.'
        format.html { redirect_to [:admin, @locale] }
        format.xml  { render :xml => @locale, :status => :created, :location => @locale }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @locale.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locales/1
  # PUT /locales/1.xml
  def update
    @locale = Locale.find_by_code(params[:id])

    respond_to do |format|
      if @locale.update_attributes(params[:locale_form])
        flash[:notice] = 'Locale was successfully updated.'
        format.html { redirect_to [:admin, @locale] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @locale.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locales/1
  # DELETE /locales/1.xml
  def destroy
    @locale = Locale.find_by_code(params[:id])
    @locale.destroy

    respond_to do |format|
      format.html { redirect_to admin_locales_path }
      format.xml  { head :ok }
    end
  end

  def refresh
    # TODO:: HACK:: OMFG:: GET RID OF THIS!!!!!!! but how?
    # There isn't a way to clear a namespace in memcached
    # There isn't a default expiry option for rails memcached
    # There is not a pleasant way to clear all cached items,
    # including stories/ideas/whatever, have to manually iterate over them
    # This is a serious issue that needs to be addressed
    # Cached fragments depend on locales and need to be invalidated with the locales
    # but how? doing a flush_all is a terrible solution.
    Rails.cache.clear
    flash[:success] = "Refreshed locales"
    redirect_to admin_locales_path
  end
end
