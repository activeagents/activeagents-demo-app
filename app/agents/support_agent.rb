class SupportAgent < ApplicationAgent
  layout "agent"
  generate_with :openai, model: "gpt-4.1-nano", 
    instructions: "You're a support agent. Your job is to help users with their questions.", stream: true

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
    tool_call_message = @chat.messages.build(generation_id: (generation_provider.response.message.generation_id || SecureRandom.uuid), role: generation_provider.response.message.role)
    tool_call_message.requested_actions = { tool_calls: generation_provider.response.message.raw_actions }
    tool_call_message.content = generation_provider.response.message.content
    tool_call_message.save!
    tool_result_message = @chat.messages.create(
      action_id: generation_provider.response.message.requested_actions.first.id,
      action_name: generation_provider.response.message.requested_actions.first.name,
      content: generation_provider.response.prompt.messages.last.content,
      role: :tool
      )
  end

  def load_context
    @chat = Chat.find(params[:context_id])
    params[:messages] = @chat.to_context.messages 
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
