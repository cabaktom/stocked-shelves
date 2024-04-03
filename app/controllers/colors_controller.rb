# frozen_string_literal: true

class ColorsController < ApplicationController
  before_action :set_color, only: %i[show edit update destroy]

  # GET /colors
  def index
    @colors = current_user.colors
  end

  # GET /colors/1
  def show; end

  # GET /colors/new
  def new
    @color = Color.new
  end

  # GET /colors/1/edit
  def edit; end

  # POST /colors
  def create
    @color = Color.new(color_params)
    @color.user_id = current_user.id

    if @color.save
      redirect_to color_url(@color), notice: 'Color was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /colors/1
  def update
    if @color.update(color_params)
      redirect_to color_url(@color), notice: 'Color was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /colors/1
  def destroy
    @color.destroy!
    redirect_to colors_url, notice: 'Color was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_color
    @color = current_user.colors.find_by_hashid(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def color_params
    params.require(:color).permit(:name, :hex_code)
  end
end
