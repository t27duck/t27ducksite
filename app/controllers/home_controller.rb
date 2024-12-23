# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @posts = Post.published.order(published_at: :desc).limit(12)
  end
end
