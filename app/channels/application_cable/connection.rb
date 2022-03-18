module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def disconnect
      close(reason: nil, reconnect: true) # From https://dev.to/ethanmgustafson/rails-6-actioncable-navigation-turbolinks-2k67
    end

    private

    def find_verified_user
      verified_user = User.find_by(id: cookies.encrypted["_strategorical_session"]["user"])

      if verified_user.present?
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
