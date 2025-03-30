module SupportAgentHelper
  
  def self.message_broadcaster(chat, message=nil)
    content = message || generation_provider.response.message.content
    puts "Broadcasting message... #{content}"
    
    broadcast_append_later_to(
      "#{dom_id(chat)}_messages",
      target: "#{dom_id(chat)}_messages",
      partial: "support_agent/message",
      locals: { message: message }
    )
  end
end