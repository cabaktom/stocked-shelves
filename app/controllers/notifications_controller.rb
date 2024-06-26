# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show edit update destroy]

  # GET /notifications
  def index
    @notifications = current_user.notifications
  end

  # GET /notifications/1
  def show; end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit; end

  # POST /notifications
  def create
    @notification = Notification.new(notification_params)
    @notification.user_id = current_user.id

    if @notification.save
      redirect_to notification_url(@notification), notice: 'Notification was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notifications/1
  def update
    if @notification.update(notification_params)
      redirect_to notification_url(@notification), notice: 'Notification was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /notifications/1
  def destroy
    @notification.destroy!
    redirect_to notifications_url, notice: 'Notification was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = current_user.notifications.find_by_id(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def notification_params
    params.require(:notification).permit(:days_before_expiration)
  end
end
