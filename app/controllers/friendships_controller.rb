class FriendshipsController < ApplicationController
  def create
  end

  def destroy
    friend = User.find(params[:id])
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    flash[:notice] = "Stopped following friend #{friend.full_name}"
    redirect_to my_friends_path
  end
end
