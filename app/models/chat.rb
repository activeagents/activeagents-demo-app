class Chat < ApplicationRecord
  include ActionView::RecordIdentifier
  has_many :messages, dependent: :destroy

  def chat_dom_id
    "#{dom_id(self)}_messages"
  end

  def find_or_create_streaming_message(generation_response)
    return nil unless generation_response.message.generation_id.present?
    
    message = messages.find_or_initialize_by(
      generation_id: generation_response.message.generation_id, 
      role: generation_response.message.role
    )
    message.content = generation_response.message.content
    message.save!
    message
  end
  
  def create_tool_messages(generation_response)
    # Create tool call message
    tool_call_message = messages.build(
      generation_id: generation_response.message.generation_id || SecureRandom.uuid,
      role: generation_response.message.role,
      content: generation_response.message.content,
      requested_actions: { tool_calls: generation_response.message.raw_actions }
    )
    tool_call_message.save!

    # Create tool result message
    first_action = generation_response.message.requested_actions.first
    tool_result_message = messages.create(
      action_id: first_action.id,
      action_name: first_action.name,
      content: generation_response.prompt.messages.last.content,
      role: :tool
    )

    [tool_call_message, tool_result_message]
  end

  def messages_from_context(context:)
    self.messages = context.messages.map do |message|
      self.messages.build(content: message.content, role: message.role)
    end
  end

  def to_context
    prompt = ActiveAgent::ActionPrompt::Prompt.new

    prompt.messages = messages.order(created_at: :asc).map do |message|
      action_message = ActiveAgent::ActionPrompt::Message.new(content: message.content, role: message.role)
      action_message.action_id = message.action_id.presence
      action_message.action_name = message.action_name.presence
      if action_message.action_requested = message.requested_actions.present?
        action_message.raw_actions = { tool_calls: message.requested_actions["tool_calls"] }
      end
      action_message
    end

    prompt
  end

  def broadcast_last_message(message)
    broadcast_append_later_to(
      "#{chat_dom_id}_messages",
      target: "#{chat_dom_id}_messages",
      partial: "support_agent/message",
      locals: {message: message}
    )
  end
end
