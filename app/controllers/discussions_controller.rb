class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, only: [:show, :edit, :destroy, :update]

  def index
    @pagy, @discussions = pagy(Discussion.includes(:category).pinned_first)
  end

  def show
    @pagy, @posts = pagy(@discussion.posts.includes(:user, :rich_text_body).order(created_at: :asc))
    @new_post = @discussion.posts.new
  end

  def new
    @discussion = Discussion.new
    @discussion.posts.new
  end

  def create
    @discussion = Discussion.new(discussion_params)

    respond_to do |format|
      if @discussion.save
        format.html { redirect_to @discussion, notice: "Discussion created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        @discussion.broadcast_replace(partial: "discussions/header", locals: { discussion: @discussion })

        if @discussion.saved_change_to_category_id?
          old_category_id, new_category_id = @discussion.saved_change_to_category_id

          old_category = Category.find(old_category_id)
          new_category = Category.find(new_category_id)

          # remove it from the old category list / insert to new list
          @discussion.broadcast_remove_to(old_category)
          @discussion.broadcast_prepend_to(new_category)

          # Update categories by replacing them. This updates the counters in the sidebar.
          old_category.reload.broadcast_replace_to("categories")
          new_category.reload.broadcast_replace_to("categories")
        end

        if @discussion.saved_change_to_closed?
          @discussion.broadcast_action_to(
            @discussion,
            action: :replace,
            target: "new_post_form",
            partial: "discussions/posts/form",
            locals: { post: @discussion.posts.new }
          )
        end

        format.html { redirect_to @discussion, notice: "Discussion updated" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discussion.destroy!
    redirect_to discussions_path, notice: 'Discussion removed'
  end

  private

  def discussion_params
    params.require(:discussion).permit(:name, :category_id, :closed, :pinned, posts_attributes: :body)
  end

  def set_discussion
    @discussion = Discussion.find(params[:id])
  end
end
