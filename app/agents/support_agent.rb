class SupportAgent < ApplicationAgent
  layout "agent"
  generate_with :openai, 
    model: "gpt-4.1-nano", 
    instructions: "You're a support agent. Your job is to help users with their questions.", 
    stream: true

  before_action :load_context
  
  on_stream :broadcast_message
  after_action :create_message, only: [:get_cat_image]
  
  def get_cat_image
    prompt(content_type: 'image_url', message: params[:message], messages: params[:messages], context_id: params[:context_id]) do |format| 
      format.text { render plain: CatImageService.fetch_base64_image } 
      format.json
    end
  end

  private 
  def create_message
    @chat.create_tool_messages(generation_provider.response)
  end

  def load_context
    @chat = Chat.find(params[:context_id])
    params[:messages] = @chat.to_context.messages 
  end

  def broadcast_message
    @chat = Chat.find(generation_provider.response.prompt.context_id)
    @message = @chat.find_or_create_streaming_message(generation_provider.response)
  end
end
