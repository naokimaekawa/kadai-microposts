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
  
  #メソッドにもなる
  #like_relationshipsをもっている
  #has_many :のあとは、mysqlのtable名
  has_many :like_relationships, dependent: :destroy #お気に入り登録中でも消すことができる[紐づくオブジェクトも消えるということ]
  has_many :likeposts, through: :like_relationships, source: :like
  #クラス、つまり、modelである
  has_many :reverses_of_like_relationships, class_name: 'LikeRelationship', foreign_key: 'like_id'
  has_many :likers, through: :reverses_of_like_relationships, source: :user
  
  # has_many :like_relationships
  # has_many :microposts, through: :like_relationships, source: :like
  
  #local変数渡し
  def like(new_micropost)
    self.like_relationships.find_or_create_by(like_id: new_micropost.id)
  end

  def unlike(like_micropost)
    like_relationship = self.like_relationships.find_by(like_id: like_micropost.id)
    like_relationship.destroy if like_relationship
  end

  def likeposts?(certain_micropost)
    self.likeposts.include?(certain_micropost)
  end
  
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
  
  def like_microposts
  #は User モデルの has_many :likes, ... によって自動的に生成されるメソッド
    Micropost.where(id: self.likepost_ids)
  end
  
end
