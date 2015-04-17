class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.text :description
      t.text :status
      t.integer :requester_id
      t.integer :assignee_id

      t.timestamps
    end
  end
end
