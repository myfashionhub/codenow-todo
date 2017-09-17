class ItemsController < ApplicationController
  def index
    @queued_items = Item.where(status: 'queued')
    @active_items = Item.where(status: 'active')
    @done_items = Item.where(status: 'done')

    # New item form
    @item = Item.new(status: 'queued')
    @statuses = Item.statuses
  end

  def show
    @item = Item.find(params[:id])
    @statuses = Item.statuses
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    redirect_to "/items/#{item.id}"
  end

  def create
    Item.create(item_params)
    redirect_to '/items'
  end

  def item_params
    params.require(:item).permit(
      :name, :description, :duration, :deadline, :status, :completed_at
    )
  end
end
