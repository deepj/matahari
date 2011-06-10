module Matahari
  module RSpec
    module Extensions
      def have_received(times = nil)
        if times 
          @calls_expected = 0
          times.each { @calls_expected+= 1 }

          Debriefing.new(@calls_expected)
        else
          Debriefing.new
        end
      end
    end
  end
end
