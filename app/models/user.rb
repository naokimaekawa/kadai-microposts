class User < ApplicationRecord
  #入力Emailの小文字化（! をつけることで、自分自身を直接変換）
  before_save { self.email.downcase! }
  #名前バリデーションの追加
  validates :name, presence: true, length: { maximum: 50 }
  #Emailバリデーションの追加
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  #Rails の標準機能にある has_secure_password を利用
  #暗号化のために bcrypt Gem が必要
  has_secure_password
end
