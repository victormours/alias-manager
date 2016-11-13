module AliasManager
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
end
