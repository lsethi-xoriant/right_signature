module RightSignature
  class Client
    module ReusableTemplates
      def reusable_templates(query = {})
        get 'reusable_templates', query
      end

      def reusable_template(reusable_template_id)
        get "reusable_templates/#{reusable_template_id}"
      end

      %i|send embed|.each do |kind|
        resource = "#{kind}_document"
        define_method resource.to_sym do |reusable_template_id, query = {}|
          post "reusable_templates/#{reusable_template_id}/#{resource}", query
        end
      end
    end
  end
end
