class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:new, :edit, :create, :update]

  respond_to :html

  # defined in ApplicationController
  # it registers helper_methods like :sort_column and :sort_direction
  sortable_by :description, :status, :requester, :assignee, default: :description

  def index
    @presenter = TodoPresenter.new(sort_column:    sort_column,
                                   sort_direction: sort_direction,
                                   page:           params[:page])
  end

  def my_todos
    @presenter = TodoPresenter.new(root:           current_user.todos_assigned,
                                   sort_column:    sort_column,
                                   sort_direction: sort_direction,
                                   page:           params[:page])

    render :index
  end

  def show
    respond_with(@todo)
  end

  def new
    @todo = Todo.new(requester: current_user)
    respond_with(@todo)
  end

  def edit
  end

  def create
    @todo = Todo.create(todo_params)
    respond_with(@todo)
  end

  def update
    @todo.update(todo_params)
    respond_with(@todo)
  end

  def destroy
    @todo.destroy
    respond_with(@todo)
  end

  private
    def todo_params
      params.require(:todo).permit(:description, :status, :requester_id, :assignee_id, :deadline)
    end

    def set_todo
      @todo = Todo.find(params[:id])
    end

    def set_users
      @users = User.order(:email)
    end
end
