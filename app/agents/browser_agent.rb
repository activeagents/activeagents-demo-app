class BrowserAgent < ApplicationAgent
  require "selenium-webdriver"
  require "capybara"

  generate_with :openai, 
    model: "gpt-4",
    instructions: :instructions,
    temperature: 0.7

  # Configure Capybara
  before_action :setup_browser
  after_action :cleanup_browser

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

  def take_screenshot
    prompt do |format|
      path = "tmp/screenshots/#{Time.current.to_i}.png"
      @browser.save_screenshot(path)
      format.text { "Screenshot saved to: #{path}" }
      format.json { {screenshot_path: path} }
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