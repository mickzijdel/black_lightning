class Admin::Finance::TransactionCategoriesController < AdminController
  include GenericController
  load_and_authorize_resource class: Finance::TransactionCategory

  # INDEX:  /finance/transaction_categories
  # SHOW:   /finance/transaction_categories/1
  # EDIT:   /finance/transaction_categories/1/edit
  # UPDATE: /finance/transaction_categories/1
  # NEW:    /finance/transaction_categories/new
  # CREATE: /finance/transaction_categories

  private

  def resource_class
    Finance::TransactionCategory
  end

  def permitted_params
    [:name, :hint, :description, :nominal_code_id, :transaction_type, :active]
  end

  def order_params
    [:name]
  end

  def base_index_database_query
    return super.active if params[:show_non_active] != '1'

    return super
  end
end
