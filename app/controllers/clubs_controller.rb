class ClubsController < ApplicationController
  layout "club"
  skip_before_action :authenticate, only: %i[random_question]
  # verify_authorized except: :random_question

  before_action :set_club, only: %i[ show edit update destroy ]

  # GET /clubs or /clubs.json
  def index
    @sort = params[:sort] || "next_delivery"
    @active_clubs = authorized_scope(Club.active)
    @active_clubs = helpers.apply_sort(@active_clubs, @sort)
    @inactive_clubs = authorized_scope(Club.inactive)
  end

  # GET /clubs/1 or /clubs/1.json
  def show
    redirect_to club_issues_path(@club)
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  def random_question
    @club = Club.find(params[:id])
    random_question = Question.order("RANDOM()").first

    if random_question
      render json: { prompt: random_question.prompt, asked_by: random_question.asked_by }
    else
      render json: { error: "No questions available" }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Club not found" }, status: :not_found
  rescue StandardError => e
    error_message = Rails.env.production? ? "An unexpected error occurred" : e.message
    render json: { error: error_message }, status: :internal_server_error
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs or /clubs.json
  def create
    @club = Club.new(club_params)
    @club.members.build(user: current_user, role: :owner, activated_at: Time.current)

    respond_to do |format|
      if @club.save
        format.html { redirect_to club_url(@club), notice: "Club was successfully created." }
        format.json { render :show, status: :created, location: @club }
      else
        flash.now[:alert] = @club.errors.full_messages.join("<br/>")
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clubs/1 or /clubs/1.json
  def update
    respond_to do |format|
      if @club.update(club_params)
        format.html { redirect_to edit_club_url(@club), notice: "Club was successfully updated." }
        format.json { render :show, status: :ok, location: @club }
      else
        flash.now[:alert] = @club.errors.full_messages.join("<br/>")
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1 or /clubs/1.json
  def destroy
    @club.destroy!

    respond_to do |format|
      format.html { redirect_to clubs_url, notice: "Club was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def join_by_code
    @club = Club.find_by!(invite_code: params[:invite_code])
    @club.members.build(user: current_user, role: :member, activated_at: Time.current)

    if @club.save
      redirect_to club_url(@club), notice: "You have joined the club"
    else
      redirect_to clubs_url, alert: @club.errors.full_messages.join("<br/>")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find(params[:id])
      authorize! @club
    end

    # Only allow a list of trusted parameters through.
    def club_params
      params.require(:club).permit(:title, :description, :active, :default_number_questions, :delivery_time, :delivery_frequency, :delivery_day, :timezone, :theme, sections: [])
    end
end
