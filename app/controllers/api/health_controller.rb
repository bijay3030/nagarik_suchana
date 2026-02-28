module Api
  class HealthController < ApplicationController
    def index
      render json: { status: "ok", message: "Rails API is running" }
    end
  end
end
