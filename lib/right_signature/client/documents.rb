module RightSignature
  class Client
    module Documents
      def documents(query = {})
        get 'documents', query
      end

      def document(document_id)
        get "documents/#{document_id}"
      end
    end
  end
end
