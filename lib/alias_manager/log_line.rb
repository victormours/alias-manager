module AliasManager
  class LogLine
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
end
