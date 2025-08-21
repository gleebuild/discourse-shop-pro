
# frozen_string_literal: true
module DiscourseShop::Instrumentation
  extend ActiveSupport::Concern

  included do
    before_action :shop_log_enter
    after_action  :shop_log_exit
    rescue_from StandardError, with: :shop_log_exception
  end

  private

  def shop_log_enter
    params_safe = request.request_parameters.dup
    # mask common sensitive fields
    %w[password token secret api_key access_token client_secret].each { |k| params_safe[k] = '[FILTERED]' if params_safe.key?(k) }
    ::DiscourseShop::Log.log!("[#{self.class.name}##{action_name}] ENTER ip=#{request.remote_ip} method=#{request.method} path=#{request.fullpath} user_id=#{current_user&.id} params=#{params_safe}")
  end

  def shop_log_exit
    ::DiscourseShop::Log.log!("[#{self.class.name}##{action_name}] EXIT  status=#{response.status}")
  end

  def shop_log_exception(ex)
    ::DiscourseShop::Log.log!("[#{self.class.name}##{action_name}] EXCEPTION #{ex.class}: #{ex.message}\n#{(ex.backtrace || [])[0..10].join("\n")}")
    raise
  end
end
