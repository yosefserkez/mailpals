class IssuesController < ApplicationController
  layout :resolve_layout
  before_action :set_issue, only: %i[ show edit update destroy deliver ]

  # GET /issues or /issues.json
  def index
    @club = Club.find(params[:club_id])
    authorize! @club, to: :show?
    @in_progress = @club.issues.in_progress
    @upcoming = @club.issues.upcoming
    @sent = @club.issues.sent
  end

  # GET /issues/1 or /issues/1.json
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
    redirect_to club_issue_path(@issue.club, @issue), notice: "Cannot edit an issue that has already been sent" if @issue.sent?
    @club = Club.find(params[:club_id])
    @issue = @club.issues.find(params[:id])
  end

  # POST /issues or /issues.json
  def create
    @issue = Issue.new(issue_params)

    respond_to do |format|
      if @issue.save
        format.html { redirect_to issue_url(@issue), notice: "Issue was successfully created." }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.turbo_stream do
          flash.now[:notice] = "Issue was successfully updated."
          render turbo_stream: turbo_stream.replace(
            "issue_form",
            partial: "form",
            locals: { issue: @issue }
          )
        end
        format.html { redirect_to edit_club_issue_path(@issue.club, @issue), notice: "Issue was successfully updated." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "issue_form",
            partial: "form",
            locals: { issue: @issue }
          )
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1 or /issues/1.json
  def destroy
    @issue.destroy!

    respond_to do |format|
      format.html { redirect_to issues_url, notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def deliver
    if @issue.sent?
      @issue.send_delivery_emails
      redirect_to club_issue_path(@issue.club, @issue), notice: "Issue delivery emails resent."
    else
      @issue.deliver
      redirect_to club_issue_path(@issue.club, @issue), notice: "Issue delivery emails sent."
    end
  end

  private

  def resolve_layout
    case action_name
    when "edit", "show", "new"
      "issue"
    else
      "club"
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_issue
    @issue = Issue.find(params[:id] || params[:issue_id])
    authorize! @issue
  end

  def issue_params
    params.require(:issue).permit(:title, :deliver_at, :open_at, sections: [], issue_questions_attributes: [ :id, :prompt, :asked_by, :category, :priority, :_destroy ])
  end
end
