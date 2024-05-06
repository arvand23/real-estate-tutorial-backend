class HousesController < ApplicationController
    before_action :authenticate_user! #built into devise
    before_action :set_house, only: [:show, :update]
    
    # GET /houses or /houses.json, return all houses and kinda like search function
    def index
        category = params[:category]
        search = params[:search]

        @houses = House.where("category LIKE '%#{category}%' AND title LIKE '%#{search}%'").order(created_at: :desc)

        render json: @houses
    end

    # GET /houses/own or /houses/own.json or owned by a specific user
    def own
       @houses = House.where(user_id: authenticate_user!.id).order(created_at: :desc)
       render json: @houses 
    end

    # GET /houses/1 or houses/1.json a specific house
    def show
        if @house 
            render json: @house
        else
            render json: nil, status: :unathorized
        end
    end

    # POST /houses or houses.json
    def create
        @house = House.new(house_params)
        @house.update_attribute(:user_id, authenticate_user!.id)
        @house.save

        render json: @house
    end

    # PATCH /houses/1 or house/1.json
    def update
        if @house 
            @house.update(house_params)
            render json: @house
        else
            render json: nil, status: :unauthorized
        end
    end

    private
    # Gets a house based on the user_id and the id of the house itself
        def set_house
            @house = House.find_by(user_id: authenticate_user!, id: params[:id])
        end

    # Whenever you want to update, create or interact with the house model, allow these params
        def house_params
            params.require(:house).permit(:title, :description, :address, :image, :category, :price, :bathroom, :bedroom, :car)
        end
end