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
    end
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

  def self.find_by_command(command)
    all.find do |aliaz|
      aliaz.command == command
    end
  end

  def abbreviation
    string.match(/alias\s+([^=]*)=/)[1]
  end

  def command
    string.match(/='?"?([^'"]*)'?"?/)[1]
  end

end

aliases = Alias.all

alias_commands = aliases.map(&:command)

commands_by_counts = Command.counts.to_h

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
puts "You should consider removing them from your zshrc."
