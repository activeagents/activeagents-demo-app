class FashionAgent < ApplicationAgent
  def catalog
    @message = "Cats go.."

    prompt message: @message
  end
end
