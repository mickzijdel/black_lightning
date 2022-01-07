  
  class Admin::Finance::BankInformationsController < AdminController
    include GenericController
    load_and_authorize_resource class: Finance::BankInformation
  
    # INDEX:  /finance/bank_informations
    # SHOW:   /finance/bank_informations/1
    # EDIT:   /finance/bank_informations/1/edit
    # UPDATE: /finance/bank_informations/1
    # NEW:    /finance/bank_informations/new
    # CREATE: /finance/bank_informations

    private

    def resource_class
      Finance::BankInformation
    end
    
    def permitted_params
      # NOTE THAT USER IS NOT PERMITTED!!!
      [:account_holder_name, :sort_code, :account_number]
    end

    def order_params
      [:account_holder_name]
    end
  end
