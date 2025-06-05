class TranslationAgent < ApplicationAgent
  generate_with :openai, instructions: "Translate the given text from one language to another."
  
  def translate
    prompt(messages: params[:messages], context_id: params[:context_id]) do |format|
      format.text { render plain: "translate: #{params[:message]}; to #{params[:locale]}" }
      format.json
    end
  end
end