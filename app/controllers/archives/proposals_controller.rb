class Archives::ProposalsController < AdminController
  include GenericController

  def index
    @title = "Proposal Archive"

    super
  end

  private

  # The original approach materialized all IDs into a Ruby array (.ids) to avoid a JOIN conflict:
  # both Ransack (user name search) and accessible_by need to JOIN team_members, which causes
  # a duplicate alias error when merged into a single query. However, a literal WHERE id IN (1000 values)
  # is very slow. Passing a relation to where(id:) instead generates a subquery, which avoids
  # both the literal list and the JOIN conflict (each query has its own scope).

  def proposal_search_result
    result_ids_query = base_index_ransack_query.select(:id)
    Admin::Proposals::Proposal.where(id: result_ids_query).accessible_by(current_ability)
  end

  def load_index_resources
    result_proposals = proposal_search_result
    call_ids = result_proposals.distinct.pluck(:call_id)

    @calls = Admin::Proposals::Call.where(id: call_ids)
                                   .reorder("submission_deadline DESC")
                                   .page(params[:page]).per(20)

    @proposals = result_proposals.where(call_id: @calls.ids)
                                 .includes(:call, team_members: :user)
                                 .order("admin_proposals_calls.submission_deadline DESC")
                                 .group_by(&:call)

    @proposals
  end

  def random_resources
    proposal_search_result
  end

  def resource_class
    Admin::Proposals::Proposal
  end

  def distinct_for_ransack
    false
  end

  # Only exists in admin form, and is in the admin namespace so does not need :admin prepended.
  def instance_url_hash(instance)
    instance
  end
end
