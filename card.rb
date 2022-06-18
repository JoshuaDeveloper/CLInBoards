require "json"
require_relative "check_item"

class Card
  attr_accessor :id, :title, :membes, :labels, :due_date, :checklist

  # rubocop:disable Metrics/ParameterLists
  def initialize(title:, members:, labels:, due_date:, checklist: [], id: nil)
    # rubocop:enable Metrics/ParameterLists
    @id = id
    @title = title
    @members = members
    @labels = labels
    @due_date = due_date
    @checklist = checklist.map { |checkitem| CheckItem.new(**checkitem) }
  end

  def to_json(_optional)
    JSON.pretty_generate({ id: @id, title: @title, members: @members, labels: @labels, due_date: @due_date,
                           checklist: @checklist })
  end

  def details
    items_completed = @checklist.select(&:completed)
    checklist = "#{items_completed.size}/#{@checklist.size}"
    [@id, @title, @members.join(", "), @labels.join(", "), @due_date, checklist]
  end

  def update(title:, members:, labels:, due_date:)
    @title = title unless title.empty?
    @members = members unless members.empty?
    @labels = labels unless labels.empty?
    @due_date = due_date unless due_date.empty?
  end

  def menu
    option = ""
    until option == "back"
      puts "Card: #{@title}"
      show_check_items
      puts "-" * 37
      puts "Checklist option: add | toggle INDEX | delete INDEX"
      puts "back"
      print "> "
      option, index = gets.chomp.split
      case option
      when "add"
        add_check_item
      when "toggle" then toggle(index.to_i)
      when "delete" then delete(index.to_i)
      end

    end
    puts "fuera"
  end

  def show_check_items
    @checklist.each_with_index { |checkitem, index| puts checkitem.to_s(index) }
  end

  def add_check_item
    print "Title: "
    title = gets.chomp
    check_item = CheckItem.new(title:)
    @checklist << check_item
  end

  def toggle(index)
    @checklist[index - 1].completed = !@checklist[index - 1].completed
  end

  def delete(index)
    @checklist.delete_at(index - 1)
  end
end
