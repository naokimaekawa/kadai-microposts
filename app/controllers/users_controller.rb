class UsersController < ApplicationController
  #follow機能前にも忘れずに
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likeposts]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    #application_controllerで定義したcount
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  #follow機能　user.rbで定義したfollowingsやfollowersを利用
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  #like機能　user.rbで定義したlike_micropostsを利用
  
  def likes #application_controllerでも使われる
    @user = User.find(params[:id])
    @likeposts = @user.like_microposts.page(params[:page])
    #application_controllerのcountsを利用。
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
