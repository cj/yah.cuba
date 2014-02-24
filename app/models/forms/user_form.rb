class UserForm < User
  after_initialize :setup_associations

  private

  def setup_associations
    unless id
      build_company
      company.build_address
    end
  end
end
