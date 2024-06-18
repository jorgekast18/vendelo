class CategoryPolicy < BasePolicy

  private def method_missing(name, *args)
    Current.user.admin?
  end
end