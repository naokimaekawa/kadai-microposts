class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
 #Helper に定義していた logged_in? を使用しているが、
 #Controller から Helper のメソッドを使うことはデフォルトではできないため
 # include Module これで、Module内のメソッドをそのクラスのインスタンスメソッドとして取り込むことができる
 # これをMix-inという
 # 逆にhelperModuleは、viewからであればどこからでも呼び出すことができる
 include SessionsHelper
 # ちなみにextend Module というのもある。これはModule内のメソッドをクラスメソッドとして取り込むときに使う
 # extend SessionsHelper
 # 
 # def self.current_user
 #   ～
 # end

  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  #Micropost の数のカウントを View で表示するとき
  def counts(user)
    @count_microposts = user.microposts.count
    #follow関連追加
    @count_followings = user.followings.count
    @count_followers = user.followers.count
  end
end