class Micropost < ApplicationRecord
  belongs_to :user
  #belongs_to :userの関連付けによって、Micropostインスタンスでインスタンスメソッド user が使えるようになる。
  #使用例：micropost.user
  #このuserメソッドで、ある投稿に紐付いたUserのインスタンスを取得することができる。
  
  validates :content, presence: true, length: { maximum: 255 }
end
