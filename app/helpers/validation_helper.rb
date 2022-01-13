module ValidationHelper
  def self.filename_validation_regex
    return { with: /\A[a-zA-Z0-9\- ]*\z/, message: 'can only contain letters, numbers, spaces, and dashes' }
  end
end
