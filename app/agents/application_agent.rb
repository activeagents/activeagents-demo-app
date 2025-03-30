class ApplicationAgent < ActiveAgent::Base
  layout "agent"

  generate_with :openai,
    model: "gpt-4o-mini", 
    instructions: "You're just a basic agent", 
    stream: true

  # Define stream callback handler

  def text_prompt
    prompt(stream: params[:stream], context_id: params[:chat_id]) { |format| format.text { render plain: params[:message] } }
  end
  
  private 

  # def agent_stream
  #   ->(message, delta = nil, stop = false) do
  #     # Custom handling logic
  #     puts "Got message: #{message}"
  #     puts "Delta content: #{delta}" if delta
  #     puts "Stream finished" if stop
  #   end
  # end
end