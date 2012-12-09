##
# Controller for Admin::Feedback. More details can be found there.
##

class Admin::FeedbacksController < AdminController

  load_and_authorize_resource :class => "Admin::Feedback"

  # GET /admin/feedbacks
  # GET /admin/feedbacks.json
  def index
    @show = Show.find_by_slug(params[:show_id])
    @feedbacks = Admin::Feedback.where({ :show_id => @show.id })

    authorize! :read, @feedbacks.first

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedbacks }
    end
  end

  # GET /admin/feedbacks/new
  # GET /admin/feedbacks/new.json
  def new
    @feedback = Admin::Feedback.new
    @show = Show.find_by_slug(params[:show_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /admin/feedbacks/1/edit
  def edit
    @feedback = Admin::Feedback.find(params[:id])
    @show = @feedback.show
  end

  # POST /admin/feedbacks
  # POST /admin/feedbacks.json
  def create
    @feedback = Admin::Feedback.new(params[:admin_feedback])
    @show = Show.find_by_slug(params[:show_id])

    @feedback.show = @show

    respond_to do |format|
      if @feedback.save
        format.html {
          if can? :read, @feedback then
            flash[:success] = 'Feedback was successfully submitted.'
            redirect_to admin_show_feedbacks_path(@show)
          else
            flash[:success] = 'Feedback was successfully submitted.'
            redirect_to admin_show_path(@show)
          end
        }
        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/feedbacks/1
  # PUT /admin/feedbacks/1.json
  def update
    @feedback = Admin::Feedback.find(params[:id])
    @show = @feedback.show

    respond_to do |format|
      if @feedback.update_attributes(params[:admin_feedback])
        format.html { redirect_to admin_show_feedbacks_path(@show), notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/feedbacks/1
  # DELETE /admin/feedbacks/1.json
  def destroy
    @feedback = Admin::Feedback.find(params[:id])
    @show = @feedback.show

    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to admin_show_feedbacks_path(@show) }
      format.json { head :no_content }
    end
  end
end