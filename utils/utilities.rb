module Utilities
  def print_table(lists:, title:, headings:)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = lists.map(&:details)
    puts table
  end

  def choose_option(options)
    puts options.join(" | ")
    print "> "
    action, id = gets.chomp.split
    [action, id.to_i]
  end

  def validate_id(prompt, list, id)
    while id.empty? || list.none? { |item| item.id == id }
      puts prompt
      print "> "
      id = gets.chomp.to_i
    end
    id
  end
end
