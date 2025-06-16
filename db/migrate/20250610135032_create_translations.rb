class CreateTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :translations do |t|
      t.references :message, null: false, foreign_key: true
      t.string :generation_id, null: true
      t.text :content
      t.string :language
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end