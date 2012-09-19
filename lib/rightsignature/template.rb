module RightSignature
  class Template
    class << self
      # List Templates and passes in optional options.
      #  Options:
      #   * page: page number
      #   * per_page: number of templates to return per page. 
      #       API only supports 10, 20, 30, 40, or 50. Default is 10.
      #   * tags: templates with specified tags. Tags are comma (,) seperated, name and value in a name/value tag should be seperated by colon (:).
      #       Ex. "single_tag,tag_key:tag_value" would find templates with 'single_tag' and the name/value of 'tag_key' with value 'tag_value'.
      #   * search: term to search for in templates.
      def list(options={})
        RightSignature::Connection.get "/api/templates.xml", options
      end
      
      def details(guid)
        RightSignature::Connection.get "/api/templates/#{guid}.xml", {}
      end
      
      def prepackage(guid)
        RightSignature::Connection.post "/api/templates/#{guid}/prepackage.xml", {}
      end
      
      # Prefills template
      # * guid: templates guid. Ex. a_1_zcfdidf8fi23
      # * subject: subject of the document that'll appear in email
      # * roles: Recipients of the document, should be an array of role names and emails in a hash with keys as role_names. 
      #     Ex. [{"Employee" => {:name => "John Employee", :email => "john@employee.com"}}]
      #       is equivalent to 
      #         <role role_name="Employee">
      #           <name>John Employee</name>
      #           <email>john@employee.com</email>
      #         </role>
      # * options: other optional values
      #     - description: document description that'll appear in the email
      #     - merge_fields: document merge fields, should be an array of merge_field_values in a hash with the merge_field_name.
      #         Ex. [{"Salary" => "$1,000,000"}]
      #           is equivalent to 
      #             <merge_field merge_field_name="Salary">
      #             <value>$1,000,000</value>
      #             </merge_field>
      #     - expires_in: number of days before expiring the document. API only allows 2,5,15, or 30.
      #     - tags: document tags, an array of {:name => 'tag_name'} (for simple tag) or {:name => 'tag_name', :value => 'value'} (for tuples pairs)
      #         Ex. [{:name => 'sent_from_api'}, {:name => "user_id", :value => "32"}]
      #     - callback_url: A URI encoded URL that specifies the location for API to POST a callback notification to when the document has been created and signed. 
      #         Ex. "http://yoursite/callback"
      # 
      # Ex. call with all options used
      #   RightSignature::Template.prefill(
      #     "a_1_zcfdidf8fi23", 
      #     "Your Employee Handbook", 
      #     [{"employee" => {:name => "John Employee", :email => "john@employee.com"}}],
      #     {
      #       :description => "Please read over the handbook and sign it.",
      #       :merge_fields => [
      #         { "Department" => "Fun and games" },
      #         { "Salary" => "$1,000,000" }
      #       ],
      #       :expires_in => 5,
      #       :tags => [
      #         {:name => 'sent_from_api'},
      #         {:name => 'user_id', :value => '32'}
      #       ],
      #       :callback_url => "http://yoursite/callback"
      #     })
      def prefill(guid, subject, roles, options={})
        xml_hash = {
          :template => {
            :guid => guid,
            :action => "prefill",
            :subject => subject
          }
        }
        
        roles_hash = []
        roles.each do |role_hash|
          name, value = role_hash.first
          roles_hash << {"role role_name=\'#{name}\'" => value}
        end
        xml_hash[:template][:roles] = roles_hash
        
        # Optional arguments
        if options[:merge_fields]
          merge_fields = []
          options[:merge_fields].each do |name, value|
            merge_field << {
              :merge_field => {
                :value => value, 
                :attributes! => {
                  :merge_field => {"merge_field_name" => name}
                }
              }
            }
          end
          xml_hash[:template][:merge_fields] = merge_fields
        end
        
        if options[:tags]
          xml_hash[:template][:tags] = []
          options[:tags].each do |tag|
            xml_hash[:template][:tags] << {:tag => tag}
          end
        end
        
        [:expires_in, :description, :callback_url, :action].each do |other_option|
          xml_hash[:template][other_option] = options[other_option] if options[other_option]
        end

        RightSignature::Connection.post "/api/templates.xml", xml_hash
      end
      
      
      # Sends template
      # * guid: templates guid. Ex. a_1_zcfdidf8fi23
      # * subject: subject of the document that'll appear in email
      # * roles: Recipients of the document, should be an array of role names and emails in a hash with keys as role_names. 
      #     Ex. [{"Employee" => {:name => "John Employee", :email => "john@employee.com"}}]
      #       is equivalent to 
      #         <role role_name="Employee">
      #           <name>John Employee</name>
      #           <email>john@employee.com</email>
      #         </role>
      # * options: other optional values
      #     - description: document description that'll appear in the email
      #     - merge_fields: document merge fields, should be an array of merge_field_values in a hash with the merge_field_name.
      #         Ex. [{"Salary" => "$1,000,000"}]
      #           is equivalent to 
      #             <merge_field merge_field_name="Salary">
      #             <value>$1,000,000</value>
      #             </merge_field>
      #     - expires_in: number of days before expiring the document. API only allows 2,5,15, or 30.
      #     - tags: document tags, an array of {:name => 'tag_name'} (for simple tag) or {:name => 'tag_name', :value => 'value'} (for tuples pairs)
      #         Ex. [{:name => 'sent_from_api'}, {:name => "user_id", :value => "32"}]
      #     - callback_url: A URI encoded URL that specifies the location for API to POST a callback notification to when the document has been created and signed. 
      #         Ex. "http://yoursite/callback"
      # 
      # Ex. call with all options used
      #   RightSignature::Template.prefill(
      #     "a_1_zcfdidf8fi23", 
      #     "Your Employee Handbook", 
      #     [{"employee" => {:name => "John Employee", :email => "john@employee.com"}}],
      #     {
      #       :description => "Please read over the handbook and sign it.",
      #       :merge_fields => [
      #         { "Department" => "Fun and games" },
      #         { "Salary" => "$1,000,000" }
      #       ],
      #       :expires_in => 5,
      #       :tags => [
      #         {:name => 'sent_from_api'},
      #         {:name => 'user_id', :value => '32'}
      #       ],
      #       :callback_url => "http://yoursite/callback"
      #     })
      def send_template(guid, subject, roles, options={})
        prefill(guid, subject, roles, options.merge({:action => 'send'}))
      end
      
      # Creates a URL that give person ability to create a template in your account
      # * options: optional options for redirected person
      #     - callback_location: URI encoded URL that specifies the location we will POST a callback notification to when the template has been created.
      #     - redirect_location: A URI encoded URL that specifies the location we will redirect the user to, after they have created a template.
      #     - tags: tags to add to the template. an array of {:name => 'tag_name'} (for simple tag) or {:name => 'tag_name', :value => 'value'} (for tuples pairs)
      #         Ex. [{:name => 'created_from_api'}, {:name => "user_id", :value => "123"}]
      #     - acceptabled_role_names: The user creating the Template will be forced to select one of the values provided. 
      #         There will be no free-form name entry when adding roles to the Template. An array of strings. 
      #         Ex. ["Employee", "Employeer"]
      #     - acceptable_merge_field_names: The user creating the Template will be forced to select one of the values provided. 
      #         There will be no free-form name entry when adding merge fields to the Template.
      #         Ex. ["Location", "Tax ID", "Company Name"]
      def generate_build_url(options={})
        xml_hash = {:template => {}}
        
        if options[:tags]
          xml_hash[:template][:tags] = []
          options[:tags].each do |tag|
            xml_hash[:template][:tags] << {:tag => tag}
          end
        end
        
        [:acceptable_merge_field_names, :acceptabled_role_names].each do |option|
          if options[option]
            xml_hash[:template][option] = []
            options[option].each do |name|
              xml_hash[:template][option] << {:name => name}
            end
          end
        end
        
        [:callback_location, :redirect_location].each do |other_option|
          xml_hash[:template][other_option] << other_option
        end

        RightSignature::Connection.post "/api/templates/generate_build_token.xml", xml_hash
      end
      
    end
  end
end