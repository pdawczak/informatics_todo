class AddDeadlineToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :deadline, :date
  end
end
