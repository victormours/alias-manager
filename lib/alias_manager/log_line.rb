module AliasManager
  class LogLine

    def self.counts
      all_with_arguments.group_by { |command| command }.map do |command, commands|
        [command, commands.count]
      end.to_h
    end

    def self.all_with_arguments
      logs = File.readlines("#{ENV['HOME']}/.zsh_history")

      logs.map do |log_line|
        command = log_line.force_encoding("iso-8859-1").split(";")[1]
        command&.chomp
      end.compact
    end

    def self.all_without_arguments
      all_with_arguments.map do |log_line|
        log_line.split(" ").first
      end
    end

  end
end
