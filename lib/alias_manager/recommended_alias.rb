module AliasManager
  class RecommendedAlias

    def all
      unaliased_history = LogLine.all_without_arguments - Alias.all.map(&:abbreviation) - Alias.all.map(&:command)
      counts = Hash.new(0)
      unaliased_history.compact.each { |w| counts[w] += 1 }

      values = {}
      counts.each do |command, times_used|
        values[command] = (command.length - 3) * times_used
      end

      values.to_a.sort_by(&:last).reverse.to_h
    end
  end

end
