# app/controllers/sessions_controller.rb
class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource
      sign_in(resource_name, resource)
      render json: { message: 'Logged in successfully.' }, status: :ok
    else
      render json: { errors: 'Invalid login credentials.' }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    head :no_content
  end

  # Sobrescreva a ação `new` para lidar com falhas de autenticação
  def new
    super
  rescue Devise::Strategies::Authenticatable::InvalidCredentials => e
    flash.now[:alert] = "Invalid login credentials."
    respond_with({}, location: new_session_path(resource_name))
  end
end
