class Admin::Finance::BudgetsController < AdminController
  include GenericController
  load_and_authorize_resource class: Finance::Budget

  # INDEX:  /finance/budgets
  # SHOW:   /finance/budgets/1
  # EDIT:   /finance/budgets/1/edit
  # UPDATE: /finance/budgets/1
  # NEW:    /finance/budgets/new
  # CREATE: /finance/budgets

  private
  def resource_class
    Finance::Budget
  end

  def permitted_params
    accepted_params = [
      :title, :notes, :event_id, :budget_category,
      team_members_attributes: %I[id _destroy position user_id],
      budget_lines_attributes: %I[id _destroy name allocated transaction_type]
    ]

    if can?(:check, @budget)
      accepted_params += [:is_draft, :status]
    end
    
    if can?(:check, @budget) || @budget.is_draft
      accepted_params += [:eutc_grant_amount]
    end
    return accepted_params
  end

  def order_args
    ['title']
  end
end
