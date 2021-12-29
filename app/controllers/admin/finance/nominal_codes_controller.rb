class Admin::Finance::NominalCodesController < AdminController
  include GenericController
  load_and_authorize_resource class: Finance::NominalCode

  # INDEX:  /admin/finance/nominal_codes
  # SHOW:   /admin/finance/nominal_codes/1
  # EDIT:   /admin/finance/nominal_codes/1/edit
  # UPDATE: /admin/finance/nominal_codes/1
  # NEW:    /admin/finance/nominal_codes/new
  # CREATE: /admin/finance/nominal_codes

  private

    def resource_class
      Finance::NominalCode
    end

    def permitted_params
      [:code, :name, :description, :active]
    end

    def order_params
      :code
    end
end
