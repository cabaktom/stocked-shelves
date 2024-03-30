# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :set_list, only: %i[show edit update destroy]

  # GET /lists
  def index
    @lists = current_user.lists
  end

  # GET /lists/1
  def show; end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit; end

  # POST /lists
  def create
    @list = List.new(list_params)
    @list.user_id = current_user.id

    if @list.save
      redirect_to list_url(@list), notice: 'List was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lists/1
  def update
    if @list.update(list_params)
      redirect_to list_url(@list), notice: 'List was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /lists/1
  def destroy
    @list.destroy!
    redirect_to lists_url, notice: 'List was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = current_user.lists.find_by_hashid(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def list_params
    params.require(:list).permit(:name, :color_id)
  end
end
