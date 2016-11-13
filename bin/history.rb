#!/usr/bin/env ruby

class Command
  def self.all
    logs = File.readlines("#{ENV['HOME']}/.zsh_history")

    logs.map do |log_line|
      log_line.force_encoding("iso-8859-1").split(";").last.chomp.split(" ").first
    end
  end

  def self.counts
    all.group_by { |command| command }.map do |command, commands|
      [command, commands.count]
    end.to_h
  end
end

class Alias < Struct.new(:string)

  def self.all
    @all ||= `echo "source #{ENV['HOME']}/.zshrc; alias -L" | /bin/zsh`.split("\n").select do |alias_line|
      alias_line[/alias\s+[^=]*=/]
    end.map do |string|
      new(string)
    end
  end

  def abbreviation
    string.match(/alias\s+([^=]*)=/)[1]
  end

  def command
    string.match(/='?"?([^'"]*)'?"?/)[1]
  end

end

commands_by_counts = Command.counts

unused_aliases = Alias.all.select do |aliaz|
  commands_by_counts[aliaz.abbreviation] == nil
end

puts "You have never used these aliases in the past #{Command.all.count} commands:"
puts unused_aliases.map(&:string)

puts "You should remove them from your zshrc."

used_once_aliases = Alias.all.select do |aliaz|
  commands_by_counts[aliaz.abbreviation] == 1
end

3.times { puts '' }
puts "You have used these aliases only once in the past #{Command.all.count} commands:"
puts used_once_aliases.map(&:string)
puts "You should use them more, or consider removing them from your zshrc."
