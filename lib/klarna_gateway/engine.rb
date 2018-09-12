module KlarnaGateway
  class Engine < Rails::Engine
    engine_name 'klarna_gateway'

    initializer "spree.klarna_gateway.payment_methods", :after => "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::Gateway::KlarnaCredit
      app.config.spree.payment_methods << Spree::Gateway::KlarnaCheckout
    end

    config.to_prepare do
      # Spree::PermittedAttributes.source_attributes << "authorization_token"
      if defined?(Spree::Admin)
        Spree::Admin::OrdersController.include(KlarnaGateway::Admin::OrdersController)
        Spree::Admin::PaymentsController.include(KlarnaGateway::Admin::PaymentsController)
        Spree::Admin::PaymentMethodsController.include(KlarnaGateway::Admin::PaymentMethodsController)
      end
      Spree::CheckoutController.prepend(KlarnaGateway::CheckoutController)
      Spree::Order.include(KlarnaGateway::Order)
      # Spree::Order.register_update_hook(:update_klarna_shipments)
      # Spree::Order.register_update_hook(:update_klarna_customer)
      Spree::Refund.include(KlarnaGateway::Refund)
      Spree::Payment.include(KlarnaGateway::Payment::Processing)
      Spree::Payment.include(KlarnaGateway::Payment::Scope)
    end
  end
end
