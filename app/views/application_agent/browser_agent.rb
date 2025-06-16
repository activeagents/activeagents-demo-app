class BrowserAgent < ActiveAgent::Base
  require "selenium-webdriver"
  require "capybara"

  generate_with :openai, 
    model: "gpt-4",
    instructions: :instructions,
    temperature: 0.7

  before_action :setup_browser
  after_action :cleanup_browser

  def take_screenshot
    prompt do |format|
      path = "tmp/screenshots/#{Time.current.to_i}.png"
      @browser.save_screenshot(path)
      format.text { "Screenshot saved to: #{path}" }
      format.json { {screenshot_path: path} }
    end
  end

  def visit_page(url)
    prompt do |format|
      @browser.visit(url)
      format.text { "Visited page: #{url}" }
      format.json { 
        { 
          title: @browser.title,
          current_url: @browser.current_url
        } 
      }
    end
  end

  def click_link(text)
    prompt do |format|
      @browser.click_link(text)
      format.text { "Clicked link: #{text}" }
      format.json { 
        {
          clicked: text,
          new_url: @browser.current_url
        }
      }
    end
  end

  def fill_form(field_name, value)
    prompt do |format|
      @browser.fill_in(field_name, with: value)
      format.text { "Filled in #{field_name} with: #{value}" }
    end
  end

  private

  def setup_browser
    return if @browser

    Capybara.register_driver :selenium_chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless') unless Rails.env.development?
      
      Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        options: options
      )
    end

    Capybara.default_driver = :selenium_chrome
    @browser = Capybara.current_session
  end

  def cleanup_browser
    @browser&.reset!
  end
end
```

Now you can use this agent with instructions that tell it how to interact with web pages:

```ruby
# app/views/browser_agent/instructions.text.erb
You are a web browser automation assistant. You can:
- Visit web pages
- Click links
- Fill in forms
- Take screenshots

Use the available actions to help users automate their web browsing tasks.
Available actions:
- visit_page(url)
- click_link(text)
- fill_form(field_name, value)
- take_screenshot()
```

Example usage:

```ruby
# Example of using the BrowserAgent
agent = BrowserAgent.prompt("Go to Google and search for 'Ruby on Rails'")
response = agent.generate_now

# The agent might execute actions like:
agent.visit_page("https://google.com")
agent.fill_form("q", "Ruby on Rails")
agent.click_link("Search")
agent.take_screenshot
```

To use this with streaming for real-time updates:

```ruby
# app/agents/browser_agent.rb
class BrowserAgent < ActiveAgent::Base
  generate_with :openai, 
    model: "gpt-4",
    stream: ->(message) { 
      Turbo::StreamsChannel.broadcast_append_to(
        "browser_actions",
        target: "browser_log",
        partial: "browser_agent/action_log",
        locals: { message: message }
      )
    }

  # ... rest of the implementation
end
```

This will broadcast browser actions in real-time using Turbo Streams. You can create a view to display the actions:

```erb
<%# app/views/browser_agent/_action_log.html.erb %>
<div class="browser-action">
  <span class="timestamp"><%= Time.current.strftime("%H:%M:%S") %></span>
  <span class="action"><%= message.content %></span>
</div>
```

Now you have an AI agent that can control a Chrome browser, with the actions exposed as methods that can be called by the LLM through the `generate_with` interface. The agent will receive natural language instructions and convert them into browser automation actions while providing real-time feedback through Turbo Streams.