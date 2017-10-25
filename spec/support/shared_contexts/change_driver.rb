shared_context "change driver" do
  include ResponsiveHelpers

  def change_driver_to(driver, &block)
    old_driver = Capybara.current_driver
    Capybara.default_driver = driver
    resize_window_desktop_store

    yield

    Capybara.current_driver = old_driver
  end
end
