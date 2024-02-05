class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  after_action :schedule_expiration_notification, only: %i[ create update ]

  # GET /items or /items.json
  def index
    @items = current_user.items
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    if item_params[:expiration].blank?
      params[:item][:notification_ids] = []
    end
    
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy!

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = current_user.items.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:quantity, :expiration, :expired, :list_id, :product_id, notification_ids: [])
    end

    def schedule_expiration_notification
      return unless current_user.notify_through_email
      return unless @item.expiration

      @item.notification.each do |notification|
        EmailExpirationNotificationJob.set(wait_until: @item.expiration - notification.days_before_expiration.days)
          .perform_later(current_user.id, @item.id, @item.expiration, notification.id)
      end
    end
end
