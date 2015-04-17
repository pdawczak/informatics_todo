json.array!(@todos) do |todo|
  json.extract! todo, :id, :description, :status, :requester_id, :assignee_id
  json.url todo_url(todo, format: :json)
end
