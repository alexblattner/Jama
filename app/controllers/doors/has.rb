module Doors
    class Has

        attr_accessor :lev
        def initialize(lev)
            @lev = lev
        end

        def this_door id
            if(id == -1)
                return false
              end
              @lev.doors
              json = JSON.parse(@lev.doors)
              has = ""
              if json.detect{|c| c == id}
                has = "checked"
              end
            has
        end
        def this_level door
            if(door.nil?)
              return ""
            end
            l = door.next_levels
            json = JSON.parse(l)
            puts "1111222222222222"
            puts l
            puts door
            puts "22222222222222"
            has = ""
            if json.detect{|c| c == @lev.id.to_s}
              has = "checked"
            end
            puts has
            has
          end     
    end
end       