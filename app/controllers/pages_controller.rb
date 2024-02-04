class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:root, :home]

  def root
    if user_signed_in?
      redirect_to dashboard_path
    else
      render :home
    end
  end

  # GET /
  def home
  end

  # GET /dashboard
  def dashboard
  end
end
