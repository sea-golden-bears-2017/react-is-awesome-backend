class FoodsController < ApplicationController
  include Authorization
  before_action :require_login
  def index
    render json: Food.all
  end

  def show
    food = Food.find_by(id: params[:id])
    if food
      render json: food
    else
      render json: { error: "Food id#{params[:id]} not found" }, status: 404
    end
  end

  def create
    require_admin
    food = Food.new(food_params)

    if food.save
      render json: food, status: :created
    else
      render json: { error: "Invalid parameters" }, status: 400
    end
  end

  def destroy
    require_admin
    food = Food.find_by(id: params[:id])
    if food
      food.destroy
      render json: { status: "destroyed" }
    else
      render json: { error: "Invalid parameters" }, status: 400
    end
  end

  private
    def food_params
      {
        name: params.fetch(:name, ''),
        unit: params.fetch(:unit, '')
      }
    end
end
