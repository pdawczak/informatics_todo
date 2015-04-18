module TodosHelper
  def format_stats(stats)
    stats.map { |status, count| "#{count} #{status}" }
         .join(", ")
  end
end
