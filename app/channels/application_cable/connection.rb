module ApplicationCable
  class Connection < ActionCable::Connection::Base

    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def disconnect
      # Any cleanup work needed when the cable connection is cut.
    end

    protected
      def find_verified_user
        :current_user
      end

  end
end
