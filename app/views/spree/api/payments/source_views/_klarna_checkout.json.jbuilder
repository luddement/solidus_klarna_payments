attrs = [:id, :order_id]
if @current_user_roles.include?("admin")
  attrs += [:response_body]
end

json.(payment_source, *attrs)
