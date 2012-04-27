class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :subject
      t.text :body
      t.string :ip_address
      t.string :name

      t.timestamps
    end
  end
end
