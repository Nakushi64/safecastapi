# frozen_string_literal: true

class DeviceStoriesController < ApplicationController
  has_scope :order

  before_action :authenticate_user!, only: %i(new create edit update destroy)

  layout :current_layout
  def index
    @device_stories = if params[:search].blank?
                        full_table
                      else
                        @search_term = params[:search].downcase
                        get_like_searched_table(@search_term)
                      end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @device_story = DeviceStory.find(params[:id])
    respond_with @device_story
  end

  def update
    puts params[:device_story][:device_story_comments_attributes]['0'][:text]
    puts 'TEST:'
    puts params.inspect
    @comment = DeviceStory.find(params[:id]).device_story_comments.create(user_id: params[:device_story][:device_story_comments_attributes]['0'][:user_id], text: params[:device_story][:device_story_comments_attributes]['0'][:text])
    respond_with DeviceStory.find(params[:id])
  end

  def get_like_searched_table(search_term)
    apply_scopes(DeviceStory).where('lower(device_urn) LIKE :search OR lower(custodian_name) LIKE :search', search: "%#{search_term}%")
      .or(apply_scopes(DeviceStory).where('lower(last_values) LIKE :search OR lower(last_location_name) LIKE :search', search: "%#{search_term}%"))
      .or(apply_scopes(DeviceStory).where('CAST(last_seen AS text) LIKE ?', "%#{search_term}%")).page(params[:page]).per(params[:per_page])
  end
  def comment_params
    params.require(:device_story).permit(device_story_comment_attributes: [:text, :user_id])
  end
  private

  def current_layout
    if params[:fullscr] == 'true'
      'full_width_device_stories'
    else
      'application'
    end
  end

  def full_table
    apply_scopes(DeviceStory).page(params[:page]).per(params[:per_page])
  end
end
