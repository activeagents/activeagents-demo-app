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

    prompt.messages = messages.map do |message|
      ActiveAgent::ActionPrompt::Message.new(content: message.content, role: message.role)
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
