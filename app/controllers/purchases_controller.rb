class PurchasesController < ApplicationController
  before_action :only_approved_users
  before_action :except_buyers, only: %i[show index]
  before_action :only_volunteers, except: %i[show index]
  def new; end

  def create; end

  def show; end

  def index; end

  def edit; end

  def update; end
end
