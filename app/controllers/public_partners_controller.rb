class PublicPartnersController < ApplicationController
  skip_before_action :check_session

  def index
    suppliers = Purchase.includes(:partner).where(active: true)
    others = Partner.where(supplier: false)
    @partners = Array(others)
    suppliers.each { |supplier| @partners << supplier.partner }
    @partners = @partners.sort_by(&:name)
    @partners
  end
end
