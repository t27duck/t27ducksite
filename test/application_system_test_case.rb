require "test_helper"

# Capybara 3.40.0's ChromeDriver#reset! clears storage between tests with
# CDP `Storage.clearDataForOrigin(origin: "*")`. Chrome 158 rejects "*" as an
# invalid URL, so every system test errors in teardown. Swap that call for
# a browser-wide cookie clear, plus a local storage clear scoped to the test
# server's origin when Capybara asks for one. Remove this once a Capybara
# release stops sending "*".
module ChromeResetWildcardOriginFix
  def execute_cdp(cmd, params = {})
    return super unless cmd == "Storage.clearDataForOrigin" && params[:origin] == "*"

    super("Network.clearBrowserCookies")

    server_url = Capybara.current_session.server&.base_url
    return unless params[:storageTypes].to_s.include?("local_storage") && server_url

    super(cmd, origin: server_url, storageTypes: "local_storage")
  end
end
Capybara::Selenium::Driver::ChromeDriver.prepend(ChromeResetWildcardOriginFix)

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV["CAPYBARA_SERVER_PORT"]
    served_by host: "rails-app", port: ENV["CAPYBARA_SERVER_PORT"]

    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: {
      browser: :remote,
      url: "http://#{ENV.fetch('SELENIUM_HOST', nil)}:4444"
    }
  else
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
end
