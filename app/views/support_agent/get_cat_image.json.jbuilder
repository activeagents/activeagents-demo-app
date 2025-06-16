json.type :function
json.function do
  json.name action_name
  json.description "This action takes no params and gets a random cat image and returns it as a base64 string."
  json.parameters do
    json.type :object
    json.properties do
      json.param_name do
        json.type :string
        json.description "The param_description"
      end
    end
  end
end