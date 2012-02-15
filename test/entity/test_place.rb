$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require "nlg"

class Test
  include Nlg

    nlg_entity :place
    nlg_fields :htemp, :rainfall => { :complement => 'cm' }

    def name
      "Pune"
    end

    def rainfall
      123
    end

    def htemp
      13
    end

    def ltemp
     12
    end

    def spew
      generate
    end
end

Test.new.spew
