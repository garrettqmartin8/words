class Post < ActiveRecord::Base
  after_save :calculate_word_count

  belongs_to :user
  belongs_to :prompt

  include PgSearch
  pg_search_scope :search_by_content, against: :content

  scope :published, -> { where(published: true) }
  scope :latest_post, -> { order("created_at desc").first || NullPost.new }

  def date
    created_at.strftime("%e %B %Y")
  end

  def publish
    update(published: true)
  end

  def unpublish
    update(published: false)
  end

  private

  def calculate_word_count
    update_column(:word_count, content.split(" ").count)
  end
end
