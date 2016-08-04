class Admin::UsersController < Admin::BaseController
  respond_to :html

  def index
    @users = User.select(
      :id, :first_name, :last_name, :email, :organisation_id, :is_admin
    )
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

    flash[:notice] = 'User was successfully created' if @user.save
    respond_with :admin, @user
  end

  def update
    @user = User.find(params[:id])

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
end
