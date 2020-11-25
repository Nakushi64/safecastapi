# frozen_string_literal: true

class DeviceStoriesController < ApplicationController
  has_scope :order
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

  def get_like_searched_table(search_term)
    apply_scopes(DeviceStory).where('lower(device_urn) LIKE :search OR lower(custodian_name) LIKE :search', search: "%#{search_term}%")
      .or(apply_scopes(DeviceStory).where('lower(last_values) LIKE :search OR lower(last_location_name) LIKE :search', search: "%#{search_term}%"))
      .or(apply_scopes(DeviceStory).where('CAST(last_seen AS text) LIKE ?', "%#{search_term}%")).page(params[:page]).per(100)
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
    apply_scopes(DeviceStory).page(params[:page]).per(100)
  end
end
