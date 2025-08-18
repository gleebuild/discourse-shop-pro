# frozen_string_literal: true
require_dependency "application_controller"

module ::DiscourseShopPro
  class LogisticsController < ::ApplicationController
    skip_before_action :verify_authenticity_token, raise: false

    def kd100_notify
      render json: { ok: true, received: params.to_unsafe_h }
    end
  end
end
