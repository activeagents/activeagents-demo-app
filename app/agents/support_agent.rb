class SupportAgent < ApplicationAgent
  layout "agent"
  generate_with :openai, model: "gpt-4o-mini", 
    instructions: "You're a support agent. Your job is to help users with their questions.", stream: true

  before_action :load_context
  
  on_stream :broadcast_message
  after_action :create_message, only: [:get_cat_image]
  after_generation :save_context
  
  def get_cat_image
    prompt(stream: true, content_type: 'image_url', message: params[:message], messages: params[:messages], context_id: params[:context_id]) do |format| 
      format.text { render plain: CatImageService.fetch_base64_image } 
      format.json
    end
  end

  private 
  def create_message
    binding.irb
    # @message = @message || @chat.messages.find_or_create_by(generation_id: generation_provider.response.message.generation_id, content: generation_provider.response.message.content, role: generation_provider.response.message.role)
  end

  def load_context
    @chat = Chat.find(params[:context_id])
    params[:messages] = @chat.to_context.messages 
  end

  def save_context
    # binding.irb
    # @chat.messages_from_context(context: generation_provider.response.prompt)
    # @chat.save
  end

  def broadcast_message
    if generation_provider.response.message.generation_id.present?
      @chat = Chat.find(generation_provider.response.prompt.context_id)
      @message = @message || @chat.messages.find_or_initialize_by(generation_id: generation_provider.response.message.generation_id, role: generation_provider.response.message.role)
      @message.content = generation_provider.response.message.content
      @message.save!
    else
      @message = nil
    end
  end 
end
