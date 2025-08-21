
# frozen_string_literal: true
class DiscourseShop::SpaController < ::ApplicationController
  requires_plugin ::DiscourseShop::PLUGIN_NAME
  skip_before_action :check_xhr
  skip_before_action :redirect_to_login_if_required

  def index
    ::DiscourseShop::Log.log!("[spa] serve /shop path=#{request.fullpath} ua=#{request.user_agent}")
    # Render blank HTML with application layout so Ember can take over routing
    render html: "", layout: true
  end
end
