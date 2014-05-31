class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body

      t.integer :post_id
      t.integer :user_id

      t.index :post_id
      t.index :user_id

      t.timestamps
    end
  end
end
