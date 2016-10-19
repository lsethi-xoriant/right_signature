module RightSignature
  class Client
    module ReusableTemplates
      def reusable_templates(query = {})
        get 'reusable_templates', query
      end

      def reusable_template(reusable_template_id)
        get "reusable_templates/#{reusable_template_id}"
      end

      def send_document(reusable_template_id, query = {})
        post "reusable_templates/#{reusable_template_id}/send_document", query
      end
    end
  end
end
