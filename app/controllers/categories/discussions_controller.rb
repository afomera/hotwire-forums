module Categories
  class DiscussionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_category

    def index
      @pagy, @discussions = pagy(@category.discussions.pinned_first)
      render 'discussions/index'
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end
  end
end
