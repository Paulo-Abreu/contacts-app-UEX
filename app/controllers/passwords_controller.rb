class PasswordsController < Devise::PasswordsController
  respond_to :json, :html
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def create
    user = User.find_by(email: resource_params[:email])
    if user
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      user.reset_password_token = enc
      user.reset_password_sent_at = Time.now.utc
      user.save(validate: false)
      render json: { reset_password_token: raw }, status: :ok
    else
      render json: { errors: ['User not found'] }, status: :not_found
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      sign_in(resource_name, resource) # Log the user in after resetting the password
      render json: { message: 'Password reset successfully.', redirect_url: root_path }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.require(:user).permit(:email, :reset_password_token, :password, :password_confirmation)
  end
end
