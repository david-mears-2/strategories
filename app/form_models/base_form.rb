# frozen_string_literal: true

class BaseForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
end
