class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    def self.sortable_by(*columns, options)
      unless options.kind_of? Hash
        columns << options
        options = {}
      end
      options = default_options_for_sorting.merge(options)

      # `sortable_by' might be configured with symbols,
      # but we'll deal with their string represenations
      # only.
      columns.map!(&:to_s)

      define_method(:sort_column) do
        sort = params[:sort]
        sort && columns.include?(sort) ? sort : options[:default]
      end

      # :sort_direction is registered only in case the
      # controller is `sortable_by'. There would not be
      # any point if we had an access for :sort_direction
      # but none columns were "registered" as :sortable_by.
      helper_method :sort_column, :sort_direction
    end

    def self.default_options_for_sorting
      { default: nil }
    end

    def sort_direction
      direction = params[:direction]
      direction && ["asc", "desc"].include?(direction) ? direction : "asc"
    end
end
