class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :user_id
      t.integer :chat_id
      t.text :body
      t.boolean :moderated

      t.timestamps
    end
    add_index :messages, :user_id
  end
end
