module RightSignature
  class Client
    module Users
      def me
        get 'me'
      end
    end
  end
end
