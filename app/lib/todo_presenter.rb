class TodoPresenter
  def initialize(root: Todo, sort_column:, sort_direction:, page:)
    @root           = root
    @sort_column    = sort_column
    @sort_direction = sort_direction
    @page           = page
  end

  def todos
    todos = root.includes(:requester, :assignee)
                .order("#{sort_by} #{sort_direction}")
                .paginate(page: page)
    
    todos = todos.joins(join) unless join.nil?

    todos
  end

  def stats
    default_stats.merge(root.group(:status).count)
  end

  private
    attr_reader :root, :sort_column, :sort_direction, :page

    def default_stats
      stats = Todo.status.values
      Hash[stats.map { |s| [s, 0] }] # => { stat_name: 0, ... }
    end

    def sort_by
      return "rel.email" if %(requester assignee).include?(sort_column)
      sort_column
    end

    def join
      if ["requester", "assignee"].include?(sort_column)
        %Q<INNER JOIN "users" "rel" ON "rel"."id" = "todos"."#{sort_column}_id">
      end
    end
end
