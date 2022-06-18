require "json"
class CheckItem
  attr_accessor :title, :completed

  def initialize(title:, completed: false)
    @title = title
    @completed = completed
  end

  def to_json(_optional)
    JSON.pretty_generate({ title: @title, completed: @completed })
  end

  def to_s(index)
    mark = @completed ? "[x]" : "[ ]"
    "#{mark} #{index + 1}. #{@title}"
  end
end
