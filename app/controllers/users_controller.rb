require_relative '../models/tagger/space_parser'
# user controller
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:edit, :destroy, :update]
  before_action :check_valid, only: [:edit, :destroy, :update]
  before_action :check_unlogin, only: [:new, :create]

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def create
    ActsAsTaggableOn.default_parser = SpaceParser
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        log_in @user
        format.html do
          redirect_to articles_path, notice: 'user was successfully created.'
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    ActsAsTaggableOn.default_parser = SpaceParser
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          redirect_to articles_path, notice: 'user was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    log_out @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to login_path, notice: 'user was destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def check_valid
    return if @user == curr_user
    redirect_to edit_user_path(curr_user.id),
                alert: 'no authorization to perform this'
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :bio,
                                 :username, :password, :interest_list,
                                 :password_confirmation, :subscribed)
  end
end
