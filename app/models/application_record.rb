class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def capitalize_first_letter
    name = self.name.split(' ')
    name.map! do |e|
      e.capitalize! unless %w[do da dos das e].include?(e)
      e
    end
    self.name = name.join(' ')
    self
  end
end
