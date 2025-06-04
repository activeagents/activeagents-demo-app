class AddActionFieldsToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :action_id, :string
    add_column :messages, :action_name, :string
    add_column :messages, :requested_actions, :json
  end
end
