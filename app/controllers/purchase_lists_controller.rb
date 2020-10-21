class PurchaseListsController < ApplicationController
  before_action :only_approved_users, :except_buyers
  def index; end
end
