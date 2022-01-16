module Finance
  def self.classes
    self.constants.select { |c| self.const_get(c).is_a? Class }.map { |model| "Finance::#{model.to_s.classify}".constantize }
  end

  def self.table_name_prefix
    'finance_'
  end
end
