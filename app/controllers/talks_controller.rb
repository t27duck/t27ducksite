# frozen_string_literal: true

class TalksController < ApplicationController
  def index
    @page_title = "Talks and Presentations"
    @talks = Post.where(kind: "talk").order(published_at: :desc).page(params[:page]).per(10)
  end
end
