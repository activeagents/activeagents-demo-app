class AddToolToMessageRoleEnum < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      ALTER TYPE message_role ADD VALUE IF NOT EXISTS 'tool'
    SQL
  end

  def down
    # Note: PostgreSQL doesn't actually support removing enum values directly
    # This will likely fail, but keeping it for completeness
    raise ActiveRecord::IrreversibleMigration, "Cannot remove enum values in PostgreSQL"
  end
end
