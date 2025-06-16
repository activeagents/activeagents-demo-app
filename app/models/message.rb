class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  enum :role, {
    system: "system", assistant: "assistant", user: "user", tool: "tool"
  }

  belongs_to :chat
  has_many :translations, dependent: :destroy

  after_create_commit -> { broadcast_created }
  after_update_commit -> { broadcast_updated }

  def find_or_create_streaming_translation(generation_response, language: nil)
    return nil unless generation_response.message.generation_id.present?
    translation = translations.find_or_initialize_by(
      language: language || 'auto'
    )
    translation.generation_id = generation_response.message.generation_id
    translation.content = generation_response.message.content
    translation.status = 'completed'
    translation.save!
    
    broadcast_replace_to(
      "#{dom_id(self.chat)}_messages",
      partial: "translations/translation",
      locals: { translation: translation },
      target: "#{dom_id(self)}_messages"
    )

    translation
  end

  def broadcast_created
    broadcast_append_later_to(
      "#{dom_id(chat)}_messages",
      partial: "messages/message",
      locals: { message: self, scroll_to: true },
      target: "#{dom_id(chat)}_messages"
    )
  end

  def broadcast_updated
    broadcast_append_to(
      "#{dom_id(chat)}_messages",
      partial: "messages/message",
      locals: { message: self, scroll_to: true },
      target: "#{dom_id(chat)}_messages"
    )
  end
end