
# frozen_string_literal: true
class DiscourseShop::Admin::BaseController < ::ApplicationController
  requires_plugin ::DiscourseShop::PLUGIN_NAME
  include ::DiscourseShop::Instrumentation
  before_action :ensure_staff
  skip_before_action :check_xhr
end
