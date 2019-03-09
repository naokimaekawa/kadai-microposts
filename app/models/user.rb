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
  
  #micropostsをもっている
  #User のインスタンスが自分の Microposts を取得することができる
  has_many :microposts
  
  #followしてる
  #User のインスタンスが自分の Relationships を取得することができる
  has_many :relationships
  #自分がfollowしている人[followings]とは、relationships[中間table]を通じて、follow.id（followings.idの方がわかりやすい気がする）を参照しなさい
  has_many :followings, through: :relationships, source: :follow
  #followされている。reverses_of_relationshipsのところは独自に決めてよい。
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  #followerとは、relationships[中間table]を通じて、user.idを参照しなさい
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  #フォロー／アンフォロー機能
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    # いればrelationshipはnilにならない
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  #タイムライン用
  #following_ids(User がフォローしている User の id の配列) 
  #は User モデルの has_many :followings, ... によって自動的に生成されるメソッド
  #user_idが、self.following_idsであるものと、self.idであるものを表示する
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
end
