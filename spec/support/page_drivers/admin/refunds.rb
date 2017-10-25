module PageDrivers
  module Admin
    class OrderPaymentsRefunds < Base
      set_url '/admin/orders/{number}/payments/{payment_id}/refunds/new'

      if KlarnaGateway.above_solidus?("2.3.0")
        element :reason_field, "#refund_refund_reason_id"
      else
        element :reason_field, 'ul.select2-results'
      end
      element :continue_button, :xpath, '//*[@id="new_refund"]/fieldset/div[2]/button'

      def select_reason!
        if KlarnaGateway.up_to_solidus?("2.2.99")
          find(".select2-arrow").click
          reason_field.all('li').last.select_option
        else
          reason_field.all('option').last.select_option
        end

      end

      def continue
        continue_button.click
      end
    end
  end
end
