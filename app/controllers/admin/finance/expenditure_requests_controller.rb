  
  class Admin::Finance::ExpenditureRequestsController < AdminController
    include GenericController
    load_and_authorize_resource class: Finance::ExpenditureRequest
  
    # INDEX:  /finance/expenditure_requests
    # SHOW:   /finance/expenditure_requests/1
    # EDIT:   /finance/expenditure_requests/1/edit
    # UPDATE: /finance/expenditure_requests/1
    # NEW:    /finance/expenditure_requests/new
    # CREATE: /finance/expenditure_requests

    private

    
    def resource_class
      Finance::ExpenditureRequest
    end
    

    def permitted_params
      # Make sure that references have _id appended to the end of them.
      # Check existing controllers for inspiration.
      # TODO: Different for new and update
      [:name, :amount_cents, :submitter_notes, :business_manager_notes, :budget_line_id, :user_id, :bank_information, :request_status, :proof_status]
    end

    def order_params
      []
    end
  end
