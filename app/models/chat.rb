class Chat < ApplicationRecord
  include ActionView::RecordIdentifier
  has_many :messages, dependent: :destroy

  def chat_dom_id
    "#{dom_id(self)}_messages"
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
