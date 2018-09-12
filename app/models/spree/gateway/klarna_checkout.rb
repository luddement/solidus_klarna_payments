module Spree
  class Gateway
    class KlarnaCheckout < Gateway
      preference :api_key, :string
      preference :api_secret, :string
      preference :country, :string, default: 'us'
      preference :payment_method, :string

      validates :preferred_country, format: { with: /\A[a-z]{2}\z/ }

      # Remove the server setting from Gateway
      def defined_preferences
        super - [:server]
      end

      def provider_class
        ActiveMerchant::Billing::KlarnaCheckoutGateway
      end

      def method_type
        'klarna_checkout'
      end

      def payment_source_class
        Spree::KlarnaCreditPayment
      end

      def source_required?
        true
      end

      def credit_card?
        false
      end

      def cancel(order_id)
        if source(order_id).fully_captured?
          provider.refund(payment_amount(order_id), order_id)
        else
          provider.cancel(order_id)
        end
      end

      def payment_profiles_supported?
        false
      end

      def source(order_id)
        payment_source_class.find_by_order_id(order_id)
      end

      def payment_amount(order_id)
        Spree::Payment.find_by(source: source(order_id)).display_amount.cents
      end

      def capture(amount, order_id, params={})
        order = spree_order(params)
        serialized_order = ::KlarnaGateway::OrderSerializer.new(order, options[:country]).to_hash
        klarna_params = {shipping_info: serialized_order[:shipping_info]}
        provider.capture(amount, order_id, params.merge(klarna_params))
      end

      private

      def spree_order(options)
        Spree::Order.find_by(number: options[:order_id].split("-").first)
      end
    end
  end
end
