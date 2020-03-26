class PagesController < ApplicationController
  before_action :check_if_signed_in

  def intro
  end

  private

  def check_if_signed_in
    redirect_to root_path if signed_in?
  end
end
