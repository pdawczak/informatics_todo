class TodosController < ApplicationController
  before_action :authenticate_user!
  helper_method :sort_column, :sort_direction

  respond_to :html

  def index
    # aunacceptably ugly code!
    # It's left here just to proceed with other
    # tasks, and address when refactoring!
    @todos = Todo
    @todos = @todos.joins(join) unless join.nil?

    sort_column_to_use = sort_column
    sort_column_to_use = "rel.email" if %(requester assignee).include?(sort_column_to_use)

    @todos = @todos.includes(:requester, :assignee)
                   .order("#{sort_column_to_use} #{sort_direction}")
                   .paginate(:page => params[:page])

    @stats = Todo.status.values
    @stats = Hash[@stats.map { |s| [s, 0] }]
    @stats = @stats.merge(Todo.group(:status).count)
  end

  def my_todos
    @todos = current_user.todos_assigned
    @todos = @todos.joins(join) unless join.nil?

    sort_column_to_use = sort_column
    sort_column_to_use = "rel.email" if %(requester assignee).include?(sort_column_to_use)

    @todos = @todos.includes(:requester, :assignee)
                   .order("#{sort_column_to_use} #{sort_direction}")
                   .paginate(:page => params[:page])

    @stats = Todo.status.values
    @stats = Hash[@stats.map { |s| [s, 0] }]
    @stats = @stats.merge(current_user.todos_assigned.group(:status).count)

    render :index
  end

  def show
    @todo = Todo.find(params[:id])
    respond_with(@todo)
  end

  def new
    @users = User.order(:email)
    @todo = Todo.new
    @todo.requester = current_user
    respond_with(@todo)
  end

  def edit
    @todo = Todo.find(params[:id])
    @users = User.order(:email)
  end

  def create
    @todo = Todo.new(todo_params)
    @users = User.order(:email) unless @todo.save
    respond_with(@todo)
  end

  def update
    @todo = Todo.find(params[:id])
    @users = User.order(:email) unless @todo.update(todo_params)
    respond_with(@todo)
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    respond_with(@todo)
  end

  private
    def todo_params
      params.require(:todo).permit(:description, :status, :requester_id, :assignee_id, :deadline)
    end

    def sort_column
      sort = params[:sort]
      sort && %w(description status requester assignee).include?(sort) ? sort : "description"
    end

    def join
      sort = params[:sort]
      if ["requester", "assignee"].include?(sort)
        "INNER JOIN 'users' 'rel' ON 'rel'.'id' = 'todos'.'#{sort}_id'"
      end
    end

    def sort_direction
      direction = params[:direction]
      direction && ["asc", "desc"].include?(direction) ? direction : "asc"
    end
end
