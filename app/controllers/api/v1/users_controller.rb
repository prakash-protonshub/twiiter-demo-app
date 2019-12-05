class Api::V1::UsersController < ApplicationController
  include Orderable
  before_action :authenticate_user!

  def user_profile
    if current_user.present?
      render json: { user: user, followers: user.followers, following: user.following, status: :success, message: 'User found successfully' }
    else
      render json: { status: :success, message: "Couldn't find user" }
    end
  end

  def follow
    user = User.find(params[:user_id])
    if current_user.following?(user)
      render json: { status: :success, message: 'Already following' }
    elsif current_user.follow_user!(user)
      render json: { status: :success, message: 'Followed successfully' }
    else
      render json: { status: :success, message: 'Failed to follow the user' }
    end
  end

  def unfollow
    user = User.find(params[:user_id])
    if current_user.following?(user)
      if current_user.unfollow_user!(user)
        render json: { status: :success, message: 'Unfollowed successfully' }
      else
        render json: { status: :success, message: 'Failed to unfollow the user' }
      end
    else
      render json: { status: :success, message: 'You are not following this user' }
    end
  end

  def followers_tweets
    tweets = Tweet.order(ordering_params(params)).where(user_id: current_user.following_ids)
    if tweets
      render json: { tweets: tweets, status: :success, message: 'Tweets found successfully' }
    else
      render json: { tweets: [], status: :success, message: 'To tweets found' }
    end
  end
end
