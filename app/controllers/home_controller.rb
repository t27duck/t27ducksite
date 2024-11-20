# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @posts = Post.published.order(published_at: :desc).limit(8)
    @talks = Talk.order(presented_on: :desc).limit(8)
  end
end
