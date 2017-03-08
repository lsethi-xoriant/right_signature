module RightSignature
  class Client
    module SendingRequests
      def sending_request(sending_request_id)
        get "sending_requests/#{sending_request_id}"
      end

      def sending_request_start(query = {})
        post "sending_requests", query
      end

      def sending_request_upload_file(path, file_path, content_type = "application/pdf")
        file = Faraday::UploadIO.new(file_path, content_type)
        conn = Faraday.new
        conn.put path, {file: file}
      end

      def sending_request_finish(sending_request_id)
        post "sending_requests/#{sending_request_id}/uploaded", {}
      end
    end
  end
end
