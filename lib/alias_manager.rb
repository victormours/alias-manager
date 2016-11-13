require_relative 'alias_manager/alias'
require_relative 'alias_manager/log_line'

module AliasManager

  def self.run
    commands_by_counts = LogLine.counts

    unused_aliases = Alias.all.select do |aliaz|
      commands_by_counts[aliaz.abbreviation] == nil
    end

    puts "You have never used these aliases in the past #{LogLine.all.count} commands:"
    puts unused_aliases.map(&:string)

    puts "You should remove them from your zshrc."

    used_once_aliases = Alias.all.select do |aliaz|
      commands_by_counts[aliaz.abbreviation] == 1
    end

    3.times { puts '' }
    puts "You have used these aliases only once in the past #{LogLine.all.count} commands:"
    puts used_once_aliases.map(&:string)
    puts "You should use them more, or consider removing them from your zshrc."
  end
end
