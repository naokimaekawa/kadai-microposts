class LikeRelationshipsController < ApplicationController
  before_action :require_user_logged_in

  def create
    #_like_buttonから来たformデータを:like_idで受ける
    
    #Micropost内で、該当のmicropostを検索
    #Micropost内で、like_idとしてmicropostのidが送られている
    micropost = Micropost.find(params[:like_id])
    current_user.like(micropost)
    flash[:success] = 'micropostをお気に入りに入れました。'
    # redirect_to root_url
    redirect_back(fallback_location: root_url)
  end

  def destroy
    #Micropost内で、該当のmicropostを検索
    #Micropost内で、like_idとしてmicropostのidが送られている
    micropost = Micropost.find(params[:like_id])
    current_user.unlike(micropost)
    flash[:success] = 'micropostをお気に入りから外しました。'
    # redirect_to root_url
    redirect_back(fallback_location: root_url)
  end
end