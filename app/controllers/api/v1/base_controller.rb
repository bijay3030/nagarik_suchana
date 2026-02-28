module Api
  module V1
    class BaseController < ApplicationController
      include ApiRespondable

      before_action :authenticate_user!
    end
  end
end
