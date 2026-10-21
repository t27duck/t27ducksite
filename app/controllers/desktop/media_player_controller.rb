class Desktop::MediaPlayerController < ApplicationController
  allow_unauthenticated_access

  def show
    @talk = Post.talk.published.find(params.expect(:talk)) if params.key?(:talk)
  end

  # The talks File > Open offers.
  def files
    @talks = Post.talk.published.order(published_at: :desc)
  end
end
