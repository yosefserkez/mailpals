class IssueQuestionsController < ApplicationController
  before_action :set_issue
  before_action :set_issue_question, only: [:edit, :update, :destroy]

  # GET /issue_questions or /issue_questions.json
  def index
    @issue_questions = @issue.issue_questions.questions
    @sections = @issue.issue_questions.sections
  end

  # GET /issue_questions/1 or /issue_questions/1.json
  def show
    @issue_questions = IssueQuestion.where(issue_id: params[:id])
    render :index
  end

  # GET /issue_questions/new
  def new
    @issue_question = @issue.issue_questions.build
  end

  # GET /issue_questions/1/edit
  def edit
  end

  # POST /issue_questions or /issue_questions.json
  def create
    @issue_question = @issue.issue_questions.build(issue_question_params)
    respond_to do |format|
      if @issue_question.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("issue-questions", partial: "issue_questions/issue_question", locals: { issue_question: @issue_question }),
          ]
        end
        format.html { redirect_to club_issue_issue_questions_path(@club, @issue), notice: "Issue question was successfully created." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("new_issue_questions_form", partial: "form", locals: { issue_question: @issue_question })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issue_questions/1 or /issue_questions/1.json
  def update
    if @issue_question.update(issue_question_params)
      redirect_to issue_issue_questions_path(@issue), notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /issue_questions/1 or /issue_questions/1.json
  def destroy
    @issue_question = @issue.issue_questions.find(params[:id])
    @issue_question.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@issue_question) }
      format.html { redirect_to issue_issue_questions_path(@issue), notice: "Question was successfully removed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:issue_id])
    end

    def set_issue_question
      @issue_question = @issue.issue_questions.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_question_params
      params.require(:issue_question).permit(:prompt, :asked_by, :category, :priority, :kind, options: [])
    end
end
