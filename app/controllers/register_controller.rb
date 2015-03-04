class RegisterController < ApplicationController
  def new
     @user = User.new
  end

  def create
    User.new(user_params)

    if @user.save
      login_as(@user)
      flash[:notice] = "You have successfully registered."
      redirect_to projects_path
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
