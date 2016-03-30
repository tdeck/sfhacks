class Admin::BlacklistsController < ApplicationController
  before_action :set_blacklist, only: [:update, :destroy]
  before_action :require_admin

  # GET /admin/blacklists
  def index
    @blacklists = Blacklist.all.order(updated_at: :desc)
  end

  # POST /admin/blacklists
  def create
    @blacklist = Blacklist.new(blacklist_params)

    respond_to do |format|
      if @blacklist.save
        format.html { redirect_to admin_blacklists_url, notice: 'Blacklist was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /admin/blacklists/1
  # TODO this is currently unused
  def update
    respond_to do |format|
      if @blacklist.update(blacklist_params)
        format.html { redirect_to admin_blacklists_url, notice: 'Blacklist was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /admin/blacklists/1
  def destroy
    @blacklist.destroy
    respond_to do |format|
      format.html { redirect_to admin_blacklists_url, notice: 'Blacklist was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blacklist
      @blacklist = Blacklist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blacklist_params
      # TODO check!
      params.permit(:id, :substring)
    end
end
