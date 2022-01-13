  
class Admin::Finance::ExpenditureRequestsController < AdminController
  include GenericController
  load_and_authorize_resource class: Finance::ExpenditureRequest
  skip_authorize_resource only: %i[new create]

  # INDEX:  /finance/expenditure_requests
  # SHOW:   /finance/expenditure_requests/1
  # EDIT:   /finance/expenditure_requests/1/edit
  def edit
    if @expenditure_request.request_sent_to_eusa? && @expenditure_request.proof_sent_to_eusa? && cannot?(:check, @expenditure_request)
      helpers.append_to_flash(:error, 'This request has already been sent to EUSA. If you want to change it, please speak to the Business Manager.')
      redirect_back fallback_location: admin_finance_expenditure_request_url(@expenditure_request)

      return
    end

    super
  end

  # UPDATE: /finance/expenditure_requests/1

  # NEW:    /finance/budgets/1/submit_expenditure_request
  def new
    budget = Finance::Budget.find(params[:budget_id])

    authorize! :submit, @budget

    # BUG: when you do not select a budget line, the form fails because the budget won't be present.
    @expenditure_request.budget = budget
    @expenditure_request.setup_bank_information

    super
  end

  # CREATE: /finance/expenditure_requests
  def create
    authorize! :submit, @budget

    @expenditure_request.setup_bank_information

    if @expenditure_request.user.nil?
      @expenditure_request.user = current_user
    end

    super
  end

  private

  def resource_class
    Finance::ExpenditureRequest
  end

  def permitted_params
    accepted_params = [:name, :expense_date, :reimbursement_method, :amount, :proof, :submitter_notes, :budget_line_id, :transaction_category_id, bank_information_attributes: [:id, :account_holder_name, :sort_code, :account_number, :user_id]]

    if can? :check, @expenditure_request
      accepted_params = accepted_params + [:user_id, :business_manager_notes, :request_status, :proof_status]
    end

    return accepted_params
  end

  def order_params
    []
  end
end
