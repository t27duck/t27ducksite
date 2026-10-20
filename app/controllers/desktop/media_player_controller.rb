class Desktop::MediaPlayerController < ApplicationController
  allow_unauthenticated_access

  def show
    @talk = Post.talk.published.find(params.expect(:talk)) if params.key?(:talk)
  end
end
