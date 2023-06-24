class Rule < ApplicationRecord
  VALID_RULE_NAMES = ["one-on-one", "threeway", "forgotten four", "the underdog", "herd mentality"].freeze

  validates :name, inclusion: { in: VALID_RULE_NAMES }
end
