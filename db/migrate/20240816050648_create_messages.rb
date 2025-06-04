class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_enum :message_role, ["user", "system", "assistant", "tool"]
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.enum :role, enum_type: :message_role, null: false
      t.text :content, null: false
      t.integer :response_number, null: false, default: 0

      t.timestamps
    end
  end
end
