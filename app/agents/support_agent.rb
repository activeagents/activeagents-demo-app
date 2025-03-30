class SupportAgent < ApplicationAgent
  layout "agent"
  generate_with :openai, model: "gpt-4o-mini", instructions: "You're a support agent. You're job is to help users with their questions."

  after_generate :create_message 

  before_action :load_context

  after_generate :save_context

  on_stream :broadcast_message
  
  def get_cat_image
    prompt(content_type: 'image_url', messages: @chat.to_context.messages) do |format| 
      format.text { render plain: get_cat_image_base64 } 
      format.json 
    end
  end

  private 
  def create_message
    # @message = @message || @chat.messages.create(content: generation_provider.response.message.content, role: 'assistant')
  end

  def load_context
    @chat = Chat.find(params[:chat_id])
  end

  def save_context
    # @chat.messages_from_context(context: prompt_context)
    # @chat.save
  end

  def broadcast_message
    @chat = Chat.find(generation_provider.prompt.context_id)
    @message = @message || @chat.messages.create(content: generation_provider.response.message.content, role: 'assistant')
    puts "Broadcasting message... #{generation_provider.response.message.content}"

    @message.update(content: generation_provider.response.message.content)
  end 
  
  def get_cat_image_base64  
    uri = URI("https://cataas.com/cat")
    response = Net::HTTP.get_response(uri)
  
    if response.is_a?(Net::HTTPSuccess)  
      image_data = response.body  
      "data:image/jpeg;base64,#{Base64.strict_encode64(image_data)}"  
    else  
      raise "Failed to fetch cat image. Status code: #{response.code}"  
    end  
  end
end
