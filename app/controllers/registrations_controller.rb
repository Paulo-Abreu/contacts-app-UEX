class RegistrationsController < Devise::RegistrationsController
    respond_to :json, :html
    skip_before_action :verify_authenticity_token, only: [:create]
  
    def new
      # Chamando o método `super` da classe `Devise::RegistrationsController`
      super
    end
  
    def create
      build_resource(sign_up_params)
  
      resource.save
      if resource.persisted?
        sign_up(resource_name, resource)
        render json: { message: 'Signed up successfully.' }, status: :created
      else
        clean_up_passwords(resource)
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
  