#app/views/toppages/index.html.erbで使用
module SessionsHelper
  # helperModuleは、viewからであればどこからでも呼び出すことができる。
  def current_user
    # 現在ログインしているUserを呼び出すメソッドを定義している
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end
end