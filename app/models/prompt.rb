class Prompt < ActiveRecord::Base
  validates :content, presence: true

  def self.today
    where(prompt_of_the_day: true).try(:first)
  end

  def self.random
    where(used: false).sample
  end

  def self.on_deck
    where(on_deck: true).try(:first)
  end

  def make_prompt_of_the_day!
    displace_old_prompt(Prompt.today)
    update(prompt_of_the_day: true, used: true, on_deck: false)
  end

  private

  def displace_old_prompt(prompt)
    return unless prompt
    prompt.update(prompt_of_the_day: false)
  end
end
