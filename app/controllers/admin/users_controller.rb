class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  respond_to :html

  before_action :load_organisations_for_dropdown, only: [:new, :create, :edit, :update]

  def index
    @users = User.select(
      :id, :first_name, :last_name, :email, :organisation_id, :is_admin
    )
    if current_user && !current_user.is_system_managers?
      @users = @users.where(organisation_id: current_user.organisation_id)
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    @organisation = @user.try(:organisation)
    @adapter = @organisation.try(:adapter)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_welcome_email
      flash[:notice] = 'User was successfully created'
    end
    respond_with :admin, @user
  end

  def update
    @user = User.find(params[:id])

    check_password_presence

    flash[:notice] = 'User was successfully updated.' if @user.update_attributes(user_params)

    respond_with :admin, @user
  end

  def destroy
    @user = User.find(params[:id])
    flash[:notice] = 'User was successfully deleted' if @user.destroy

    respond_with :admin, @user
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :organisation_id, :is_admin)
  end

  def check_password_presence
    if !user_params[:password].present? &&
      !user_params[:password_confirmation].present?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
  end

  def load_organisations_for_dropdown
    @organisations = Organisation.includes(:country).select(
      :id, :name, :role, :country_id
    ).order(:role, 'countries.name', :name)
    @organisations_for_dropdown = @organisations.map { |o| [o.display_name, o.id] }
    @organisations_names = @organisations.map { |o| [o.name, o.id] }
    @organisations_tokens = @organisations.map { |o| [o.adapter.try(:auth_token), o.id ] }
  end
end
