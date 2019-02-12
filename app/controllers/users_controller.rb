class UsersController < ApplicationController

  before_action :find_current_user, only: [:move_up, :move_down, :completed, :rated, :history, :dashboard]

  def index
    @users = User.all
  end

  def new
      @user = User.new
  end

  def create

      @user = User.create(user_params)
      if @user.valid?
        log_in @user
          redirect_to user_path(@user)
      else
          flash[:errors] = @user.errors.full_messages

          redirect_to '/'
      end
  end

  def dashboard
    @media = @user.sorted_queued_list
    @completed_media = @user.completed_queued_list
  end

  def move_up
    @medium = Medium.find(params[:medium_id])
    @user.move_medium_up(@medium)
    redirect_to user_path(@user)
  end

  def move_down
    @medium = Medium.find(params[:medium_id])
    @user.move_medium_down(@medium)
    redirect_to user_path(@user)
  end

  def completed
    @queued_medium = QueuedMedium.find_by(medium_id: params[:medium_id], user_id: params[:user_id])
    @queued_medium.update(completed:true)
  end

  def rated
    RatingRecord.create(user_id: params[:user_id], medium_id: params[:medium_id], rated_score: params[:category])
    redirect_to user_path(@user)
  end

  def history
  end

  def show
    @user = User.find(params[:id])
    @media = @user.sorted_queued_list
  end

  private

  def user_params
      params.require(:user).permit(
          :email,
          :name,
          :password
      )
  end

  def find_current_user
      @user = current_user
  end

end
