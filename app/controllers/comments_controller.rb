class CommentsController < ApplicationController
  before_action :get_device_story
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  # GET /comments
  # GET /comments.json
  def index
    @comments = @device_story.comments
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = @device_story.comments.build
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    puts '****************|  COMMENT CREATE |*******************'
    params.inspect
    @comment = @device_story.comments.build(comment_params)
    puts 'SUCCESSFULLY SAVED'
    respond_to do |format|
      if @comment.save
        format.js {render inline: "location.reload();" }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to device_story_path(@device_story), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    redirect_to device_story_path(@device_story)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = @device_story.comments.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.inspect
      params.require(:comment).permit(:content, :device_story_id, :user_id)
    end

    def get_device_story
      @device_story = DeviceStory.find(params[:device_story_id])
    end
end
