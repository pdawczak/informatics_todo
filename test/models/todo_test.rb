require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  def test_valid
    todo = Todo.new
    todo.requester_id = 1
    assert todo.valid?

    todo.requester = nil
    refute todo.valid?
  end
end
