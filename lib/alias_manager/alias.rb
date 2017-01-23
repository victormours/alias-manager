module AliasManager
  class Alias < Struct.new(:string)

    def self.all
      load_aliases = `echo "source $HOME/.zshenv; source $HOME/.zshrc; alias -L" | /bin/zsh`
      @all ||= load_aliases.split("\n").select do |alias_line|
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
