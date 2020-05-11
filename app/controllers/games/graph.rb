module Games
    class Graph

        attr_accessor :game
        attr_accessor :start_level_id
        attr_accessor :levels
        attr_accessor :doors 

        def initialize(game, start_level_id, levels, doors, errors)
            @game = game
            @start_level_id = start_level_id
            @levels = levels
            @doors = doors
            @errors = errors
        end

        def valid
            g = GraphViz.new( :G, :type => :digraph)
            valid = true
            visited_door = Array.new
            visited_level = Array.new
            door_queue = Array.new
            level_queue = Array.new
            @errors = Array.new
            level_nodes = Hash.new
            @levels.each do |level|
                level_nodes[level.id] = g.add_nodes(level.name, :fontname => "Courier")
                visited_level[level.id] = false
            end
            door_nodes = Hash.new
            @doors.each do |door|
             door_nodes[door.id] = g.add_nodes(door.name, :shape => 'square', :fontname => "Courier")
            visited_level[door.id] = false
            end
            # Breadth first search with an extra step for doors
            if(!@start_level_id.nil?)
                level_queue.push(@start_level_id)
                while level_queue.length > 0
                    curr = level_queue.pop
                    if !(visited_level[curr])
                        visited_level[curr] = true
                        curr_level = @levels.find(curr)
                        next_doors = curr_level.doors
                        door_queue = JSON.parse(next_doors)
                        while door_queue.length > 0
                            curr_door = door_queue.pop
                            if !(visited_door[curr_door])
                                visited_door[curr_door] = true
                                puts "*******"
                                puts curr
                                puts curr_door
                                puts "**********"
                                g.add_edges(level_nodes[curr], door_nodes[curr_door])
                                door_pointer = @doors.find(curr_door)
                                next_levels = JSON.parse(door_pointer.next_levels)
                                next_levels.each do |level|
                                    if !visited_level[level.to_i]
                                        level_queue.push(level.to_i)
                                    end
                                    puts "*******"
                                    puts level
                                    puts curr_door
                                    puts "**********"
                                    g.add_edges(door_nodes[curr_door], level_nodes[level.to_i])
                                end
                            end
                        end
                    end
                end
            else
                @errors.push("No starting level")
                valid = false
            end
            g.output( :png => "app/assets/images/hello_world.png" )  
            @game.graph_image.attach(io: File.open("app/assets/images/hello_world.png"), filename: "hello_world.png")
            t = GraphViz::Theory.new( g )
            g.each_node do |name, node|
              if t.degree(node) == 0
                @errors.push("Unconnected level: #{name}")
                valid = false
              end
            end
            hash = Hash.new
            hash[:errors] = @errors
            hash[:valid] = valid
            return hash
        end     
    end
end       