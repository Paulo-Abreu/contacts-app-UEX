class ContactsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  def show
    @contact = current_user.contacts.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @contact }
    end
  end
  
  def index
    @contacts = current_user.contacts
    respond_to do |format|
      format.html
      format.json { render json: @contacts }
    end
  end

  def new
  end

  def destroy
    @contact = Contact.find(params[:id])
    
    if @contact.destroy
      render json: { message: 'Contact successfully deleted' }, status: :ok
    else
      render json: { error: 'Failed to delete contact' }, status: :unprocessable_entity
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @contact }
    end
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update(contact_params)
      render json: { message: 'Contact updated successfully' }, status: :ok
    else
      render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    @contact = current_user.contacts.build(contact_params)
    if @contact.save
      render json: { message: 'Contact created successfully' }, status: :created
    else
      Rails.logger.debug "Validation errors: #{@contact.errors.full_messages.join(', ')}"
      render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :address, :zipcode, :cpf, :phone)
  end
end
