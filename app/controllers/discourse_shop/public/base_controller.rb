
# frozen_string_literal: true
class DiscourseShop::Public::BaseController < ::ApplicationController
  requires_plugin ::DiscourseShop::PLUGIN_NAME
  include ::DiscourseShop::Instrumentation
  skip_before_action :check_xhr
  skip_before_action :redirect_to_login_if_required, only: [:index, :show]
end
