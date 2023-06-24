class Entry < ApplicationRecord
  belongs_to :list
  has_many :votes

  before_save do
    # Normalize words in the list so that we correctly score words as the same if they are spelt as e.g. 'dog' & 'Dogs'.
    self.content = content.downcase.singularize
  end
end
