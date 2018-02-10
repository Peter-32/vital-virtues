module MainHelper

    # Logs in the given user
    def log_in(user)
      session[:user_id] = user.id # This places a temporary cookie and encrypts it based on the user id
      # This is safe from attackers as long as we're using temporary cookies
    end

    # Returns the current logged-in user (if any).
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    # Returns true if the user is logged in, false otherwise.
    def logged_in?
      !current_user.nil?

    end

    def log_out
      session.delete(:user_id)
      @current_user = nil
    end
end
