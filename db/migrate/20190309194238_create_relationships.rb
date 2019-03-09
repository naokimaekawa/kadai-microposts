class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      #名前が違うが、followはあくまでもuser_idを見に行くため
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps
      #unique条件付加で自分をフォローするようなことのないよう変更
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
