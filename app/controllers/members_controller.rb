class MembersController < ApplicationController
  layout "club"
  before_action :set_club, except: %i[accept deny]
  include MembersHelper

  # GET /members or /members.json
  def index
    @members = visible_members
  end

  # GET /members/1 or /members/1.json
  def show
    @members = @club.members
    render :index
  end

  # GET /members/new
  def new
    @member = @club.members.build
    authorize! @club, to: :manage?
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members or /members.json
  def create
    authorize! @club, to: :manage?
    @user = User.find_or_initialize_by(email: member_params[:user_email]) do |user|
      user.name = member_params[:display_name]
      user.password = SecureRandom.base58
    end
    @member = @club.members.build(user: @user, role: member_params[:role])

    respond_to do |format|
      if @member.save
        send_invitation(@member, @club)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("members-table-body", partial: "members/member", locals: { member: @member })
          ]
        end
        format.html { redirect_to club_members_url(@club), notice: "Member was successfully created." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("new_member_form", partial: "form", locals: { member: @member })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    @member = @club.members.find(params[:id])
    authorize! @member, to: :update?

    if member_params[:role].present? && Member.roles[member_params[:role]] > Member.roles[@member.role]
      flash.now[:alert] = "You cannot make #{@member.display_name} an owner."
      params[:member].delete(:role)
    end

    if @member.update(member_params)
      respond_to do |format|
        flash.now[:notice] = "#{@member.display_name } successfully updated."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/toast"),
            turbo_stream.replace(@member, partial: "members/member", locals: { member: @member })
          ]
        end
      end
    else
      flash.now[:alert] = @member.errors.full_messages.join(", ")
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("edit_member_#{@member.id}", partial: "form", locals: { member: @member })
        end
      end
    end
  end

  def accept
    @member = Member.find_by(club_id: params[:club_id], user: current_user)
    @member.accept_invitation
    redirect_to clubs_path, notice: "Invitation accepted"
  end

  def deny
    @member = Member.find_by(club_id: params[:club_id], user: current_user)
    @member.destroy
    redirect_to clubs_path, notice: "Invitation denied"
  end

  def destroy
    @member = @club.members.find(params[:id])
    @member.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@member) }
      format.html { redirect_to club_members_path(@club), notice: "Member was successfully made an admin." }
    end
  end

  def change_role
    unless current_user.owner_of?(@club)
      redirect_to club_members_path(@club), alert: "You are not authorized to change roles."
      return
    end
    @member = @club.members.find(params[:id])
    @member.update(role: params[:role])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@member, partial: "members/member", locals: { member: @member }) }
      format.html { redirect_to club_members_path(@club), notice: "Member was successfully made an owner." }
    end
  end

  def resend_invitation
    @member = @club.members.find(params[:id])
    send_invitation(@member, @club)
    respond_to do |format|
      format.html { redirect_to club_members_path(@club), notice: "Invitation was successfully resent." }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def member_params
    params.require(:member).permit(:display_name, :user_email, :role, hidden_member_ids: [])
  end

  def set_club
    @club = Club.find(params[:club_id])
  end

  def send_invitation(member, club)
    UserMailer.with(inviter: club.membership(current_user), user: member.user, club: club).invitation_instructions.deliver_later
    member.update(invitation_sent_at: DateTime.current)
  end
end
