class TodosController < ApplicationController
  before_action :authenticate_user!
  helper_method :sort_column, :sort_direction

  respond_to :html

  def index
    @todos   = Todo.includes(:requester, :assignee).order("#{sort_column} #{sort_direction}").paginate(:page => params[:page])
    @done    = Todo.where(status: 'done').count
    @started = Todo.where(status: 'started').count
    @new     = Todo.where(status: 'new').count
  end

  def my_todos
    @todos = Todo.includes(:requester, :assignee)
      .order("#{sort_column} #{sort_direction}").paginate(:page => params[:page])
      .where(assignee_id: current_user.id)
    @done    = Todo.where(status: 'done').count
    @started = Todo.where(status: 'started').count
    @new     = Todo.where(status: 'new').count

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
      params.require(:todo).permit(:description, :status, :requester_id, :assignee_id)
    end

    def sort_column
      sort = params[:sort]
      sort && ["description", "status", "requester"].include?(sort) ? sort : "description"
    end

    def sort_direction
      direction = params[:direction]
      direction && ["asc", "desc"].include?(direction) ? direction : "asc"
    end
end
