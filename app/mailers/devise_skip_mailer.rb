class DeviseSkipMailer < Devise::Mailer
    def confirmation_instructions(record, token, opts = {})
      # Do nothing
    end
  
    def reset_password_instructions(record, token, opts = {})
      # Do nothing
    end
  
    def unlock_instructions(record, token, opts = {})
      # Do nothing
    end
  
    def email_changed(record, opts = {})
      # Do nothing
    end
  
    def password_change(record, opts = {})
      # Do nothing
    end
  end
  