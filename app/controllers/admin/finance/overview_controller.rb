class Admin::Finance::OverviewController < AdminController
  skip_authorization_check

  def allocated_actual

    if params[:page].blank?
      params[:page] = 'budgets'
    end

    @title = "Allocated and Actual - #{params[:page].titleize}"

    # Would be nice to have some blank rows separating the categories
    # https://stackoverflow.com/questions/9738876/inserting-a-blank-table-row-with-a-smaller-height

    case params[:page]
    when 'budgets'
      @headers = ['Title', 'Allocated Expenses', 'Actual Expenses', 'Allocated Income', 'Actual Income', 'Allocated Net', 'Actual Net']
      grouped_items = Finance::Budget.active.group_by(&:budget_category)

      @field_sets = []

      totals = [0, 0, 0, 0, 0, 0]

      grouped_items.each do |budget_category, budgets|
        sub_totals = [0, 0, 0, 0, 0, 0]

        budgets.each do |budget|
          values = [budget.total_allocated_expenses, budget.total_actual_expenses, budget.total_allocated_income, budget.total_actual_income, 0, 0]
          values[4] = values[0] + values[2]
          values[5] = values[1] + values[3]

          # Add the current values to the sub totals.
          sub_totals = [sub_totals, values].transpose.map(&:sum)

          @field_sets << [helpers.get_link(budget, :show)] + values.map { |item| helpers.humanized_money_with_symbol(item) }
        end

        sub_total_line = ["#{budget_category.pluralize.titleize} Total"] + sub_totals.map { |item| helpers.humanized_money_with_symbol(item) }
        @field_sets << helpers.bold(sub_total_line)

        # Add the sub totals to the totals.
        totals = [totals, sub_totals].transpose.map(&:sum)
      end

      if grouped_items.length > 1
        total_line = ['Total'] + totals.map { |item| helpers.humanized_money_with_symbol(item) }
        @field_sets << helpers.bold(total_line)
      end
    when 'budget_by_transaction_type'
    when 'transaction_categories'
    when 'nominal_codes'
    else
      raise(ActionController::RoutingError, "The type \"#{params[:page]}\" for an allocated_actual overview does not exist.")
    end
  end
end
