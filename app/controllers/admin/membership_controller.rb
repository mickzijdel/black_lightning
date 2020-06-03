class Admin::MembershipController < AdminController
  # A json function to check if the given membership number or name
  # belongs to a current member.
  # Works with a GET
  def check_membership
    search = params[:search]

    return render json: {}, status: :not_found if search.blank?

    # Try a membership card
    card = MembershipCard.find_by_card_number(search)

    # We're not using membership cards, but can be reactivated.
    # :nocov: 
    unless card.nil?
      if card.user.nil?
        render :json, { response: 'Card Not Activated' }, status: :expectation_failed
        return
      else
        user = card.user
      end
    end
    # :nocov:

    # Else, search for a user
    q = "%#{search}%"
    user ||= User.where("CONCAT(first_name, ' ', last_name) like ?", q).first

    if user.nil?
      render json: { response: 'Member not found' }, status: :not_found
    elsif user.has_role?(:member)
      render json: { response: user.name(current_user) + ' is a current member', image: user.avatar.url }
    else
      render json: { response: user.name(current_user) + ' is not a current member' }, status: :payment_required
    end

    return
  end
end