# frozen_string_literal: true

class Admin::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @published_posts = Post.published.includes(:tags).order(created_at: :desc)
    @unpublished_posts = Post.unpublished.includes(:tags).order(published_at: :desc)
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to admin_posts_path, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to admin_posts_path, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "Post was successfully destroyed."
  end

  def preview
    @content = params[:content]
    render layout: false
  end

  private ######################################################################

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.expect(post: [:title, :content, :summary, :publish, :tags_input])
  end
end
