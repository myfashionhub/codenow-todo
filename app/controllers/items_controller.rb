class ItemsController < ApplicationController
  def index
    @queued_items = Item.where(status: 'queued')
    @active_items = Item.where(status: 'active')
    @done_items = Item.where(status: 'done')

    # New item form
    @item = Item.new(status: 'queued')
    @statuses = Item.statuses
    @form_type = 'new'
  end

  def show
    @item = Item.find(params[:id])
    @statuses = Item.statuses
    @form_type = 'edit'
  end

  def update
    item = Item.find(params[:id])

    item.assign_attributes(item_params)
    if item.status == 'done'
      item.completed_at = Time.now
    end
    item.save

    redirect_to "/items/#{item.id}"
  end

  def create
    item = Item.new(item_params)
    item.save
    redirect_to '/items'
  end

  def item_params
    params.require(:item).permit(
      :name, :description, :duration, :deadline, :status, :completed_at
    )
  end
end
