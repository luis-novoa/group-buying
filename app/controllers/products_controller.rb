class ProductsController < ApplicationController
  before_action :only_volunteers, :only_approved_users

  def new; end

  def create; end

  def index; end

  def edit; end

  def update; end

  def destroy; end
end
