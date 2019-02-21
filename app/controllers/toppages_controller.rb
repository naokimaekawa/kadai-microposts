class ToppagesController < ApplicationController
  
  def index
  #Controller のデフォルト機能として、アクションの最後に render :自身のアクション名 を呼び出し
  #render :index であり、ToppagesController なので app/views/toppages/index.html.erb が呼び出される決まりです。
  #render を自前で書き込んだ場合には自前コードが優先される
  end
end
