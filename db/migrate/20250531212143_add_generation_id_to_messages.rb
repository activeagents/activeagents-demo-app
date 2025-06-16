class AddGenerationIdToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :generation_id, :string, null: true, comment: "ID of the generation associated with this message"
    add_index :messages, :generation_id, unique: true, name: "index_messages_on_generation_id", comment: "Index for generation ID to ensure uniqueness"
  end
end
