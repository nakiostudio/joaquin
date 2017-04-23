class StepTypesController < ApplicationController

  def category
    path = params[:category_path]
    paths = path.split('/').reverse
    path_touched = ''
    category = Rails.application.config.root_category

    # Search right category among current category subcategories
    while path != 'root' && !paths.empty? && !category.nil? do
      path_touched << "#{paths.pop}/"
      categories = category.subcategories.select { |c| c.category_path == path_touched }

      # If no category has been found break loop
      if categories.empty?
        category = nil
        break
      end

      # Found
      category = categories.first
    end

    # Return 404 if no category has been found
    if category.nil?
      render status: 404, json: {}
      return
    end

    render status: 200, json: category_payload(category)
  end

  private

  def category_payload(category)
    return {
      plugins: category.plugins,
      subcategories: category.subcategories.map { |c|
        { name: c.name, path: c.category_path }
      }
    }
  end

end
