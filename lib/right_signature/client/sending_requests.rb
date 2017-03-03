module RightSignature
  class Client
    module SendingRequests
      def sending_request(sending_request_id)
        get "sending_requests/#{sending_request_id}"
      end

      def start_sending_request(query = {})
        post "sending_requests", query
      end

      def upload_sending_request_file(path, file_path, content_type = "application/pdf")
        file = Faraday::UploadIO.new(file_path, content_type)
        conn = Faraday.new
        conn.put path, {file: file}
      end

      def finish_sending_request(sending_request_id)
        post "sending_requests/#{sending_request_id}/uploaded", {}
      end
    end
  end
end
