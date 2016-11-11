#!/usr/bin/env ruby

logs = File.readlines("#{ENV['HOME']}/.zsh_history")
latest_logs = logs[-10..-1]

log_commands = logs.map do |log_line|
  log_line.force_encoding("iso-8859-1").split(";").last.chomp.split(" ").first
end

aliases = `echo "source #{ENV['HOME']}/.zshrc; alias -L" | /bin/zsh`.split("\n").select do |alias_line|
  alias_line[/alias\s+[^=]*=/]
end

alias_commands = aliases.map do |alias_line|
  alias_line.match(/alias\s+([^=]*)=/)[1]
end

grouped_commands = log_commands.group_by do |command|
  command
end

commands_by_counts = grouped_commands.map do |command, commands|
  [command, commands.count]
end.sort_by do |command_count|
  -command_count[1]
end.to_h

unused_aliases = alias_commands - commands_by_counts.map(&:first)
puts "You are not using these aliases:"
puts unused_aliases

alias_usage = alias_commands.map do |alias_command|
  [alias_command, commands_by_counts[alias_command]]
end

