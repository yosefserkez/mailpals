class AnswersController < ApplicationController
  layout "issue", only: %i[new edit]
  before_action :set_current, only: %i[new edit create destroy]

  def index
    redirect_to club_issues_url(@club)
  end

  def show; end

  def new
    @sqa = @issue.sections_questions_answers(@member)
  end

  def edit
    redirect_to club_issue_path(@issue.club, @issue), notice: "Cannot edit an issue that has already been sent" if @issue.sent?
    @sqa = @issue.sections_questions_answers(@member)
  end

  def create
    begin
      Answer.transaction do
        @answers = answer_params.to_h.map do |id, answer_data|
          answer = Answer.find_or_initialize_by(
            issue_question_id: id,
            member: @member,
          )
          answer.update!(
            answer_data.except(:images)
          )
          answer.images.attach(answer_data[:images]) if answer_data[:images].present?
        end
        if params[:photo_ids_to_delete].present?
          params[:photo_ids_to_delete].each do |id|
            ActiveStorage::Blob.find(id).attachments.each(&:purge)
          end
        end
      end
      redirect_to club_issues_url(@club), notice: "Answers were successfully created.", flash: { confetti: true }
    rescue ActiveRecord::RecordInvalid => exception
      flash.now[:alert] = exception.record.errors.full_messages.join("<br/>")
      @sqa = @issue.sections_questions_answers(@member)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.answers.where(member: @member).destroy_all
    redirect_to answers_url, notice: "Answer was successfully destroyed."
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_current
    @club = Club.find(params[:club_id])
    authorize! @club, to: :show?
    @member = @club.membership(current_user)
    @issue = @club.issues.find(params[:issue_id])
  end

  def answer_params
    params.permit(answers: [ :issue_question_id, :content, images: [], photo_ids_to_delete: [] ]).require(:answers)
  end
end
