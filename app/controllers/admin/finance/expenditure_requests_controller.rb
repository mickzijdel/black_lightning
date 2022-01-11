  
  class Admin::Finance::ExpenditureRequestsController < AdminController
    include GenericController
    load_and_authorize_resource class: Finance::ExpenditureRequest
    skip_authorize_resource only: %i[new create]

    # INDEX:  /finance/expenditure_requests
    # SHOW:   /finance/expenditure_requests/1
    # EDIT:   /finance/expenditure_requests/1/edit
    # UPDATE: /finance/expenditure_requests/1

    # NEW:    /finance/budgets/1/submit_expenditure_request
    def new
      budget = Finance::Budget.find(params[:budget_id])

      authorize! :submit, @budget

      @expenditure_request.budget = budget
      @expenditure_request.bank_information = Finance::BankInformation.new

      super
    end

    # CREATE: /finance/expenditure_requests
    def create
      authorize! :submit, @budget

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
      # TODO: Make sure the parameters are correct
      accepted_params = [:name, :amount, :submitter_notes, :budget_line_id, :bank_information, bank_information_attributes: [:account_holder_name, :sort_code, :account_number, :user_id]]


      if can? :check, @expenditure_request
        accepted_params = accepted_params + [:user_id, :business_manager_notes, :request_status, :proof_status]
      end

      return accepted_params
    end

    def order_params
      []
    end
  end
