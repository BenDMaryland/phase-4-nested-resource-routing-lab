class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    def index
      if params[:user_id]
     

      user =User.find(params[:user_id])
      items =user.items
      render json: items
      else

      items = Item.all
      render json: items, include: :user
      end
    end

    def show
      if params[:user_id]
        user =User.find(params[:user_id])
        useritem = Item.find(params[:id])
        item = user.items.find{ |item|  useritem == item}
        
      else
        item = Item.find( params[:id])
      end
      render json: item
    end


    def create
    user =User.find(params[:user_id])
    item = user.items.create(item_params)
    render json: item, status: :created
    end


private

def find_user
  User.find(params[:user_id])
end



def item_params
params.permit(:name, :description, :price)
end

def render_not_found
  render json: {error: "eror"}, status: :not_found
 end

def render_unprocessable_entity_response(invalid)
  render json: {errors: invalid.record.errors}, status: :unprocessable_entity
end

    # t.string "name"
    # t.string "description"
    # t.integer "price"
    # t.integer "user_id", null: false
    # t.datetime "created_at", precision: 6, null: false
    # t.datetime "updated_at", precision: 6, null: false
    # t.index ["user_id"], name: "index_items_on_user_id"


end
