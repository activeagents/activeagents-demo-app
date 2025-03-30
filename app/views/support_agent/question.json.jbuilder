json.type :function
json.function do
  json.name action_name
  json.description "Question to answer"
  json.parameters do
    json.type :object
    json.properties do
      json.message do
        json.type :string
        json.description "The message in questions"
      end
    end
  end
end