module Events
    class Json

        attr_accessor :params
        def initialize(params)
            @params = params
        end

        def createFightJSON 
            result = ""
            result += "{\"hp\":"
            if(@params['enemy_hp'].nil?)
              result += ""
            else
              result += @params['enemy_hp']
            end
            result += ", \"attack\": { \"hp\":"
            if(@params['enemy_attack_hp'].nil?)
              result += ""
            else
              result += (@params['enemy_attack_hp'].to_i * -1).to_s
            end
            result += ", \"exp\":"
            if(@params['enemy_attack_exp'].nil?)
              result += ""
            
            else
              result += (@params['enemy_attack_exp'].to_i * -1).to_s 
            end
            result += ", \"gold\":"
            if(@params['enemy_attack_gold'].nil?)
              result += ""
            else
              result += (@params['enemy_attack_gold'].to_i * -1).to_s 
            end
            # "death" :["hp": 1, "exp": 1, "gold": 1]
            result += "}, \"death\": {\"hp\":"
            if(@params['enemy_death_hp'].nil?)
              result += ""
            
            else
              result += @params['enemy_death_hp'] 
            end
            result += ", \"exp\":"
            if(@params['enemy_death_exp'].nil?)
              result += ""
            else
              result += @params['enemy_death_exp'] 
            end
            result += ", \"gold\":"
            if(@params['enemy_death_gold'].nil?)
              result += ""
            else
              result += @params['enemy_death_gold'] 
            end
            result += "}}"
            result
          end
          def createRequirementJSON
            req = "{"
            if(!@params['event_req_hp'].nil? && !(@params['event_req_hp'].to_i == 0))
              req += "\"hp\":"
              req += "\"" + @params['event_req_hp_operator'].to_s
              req += @params['event_req_hp'] + "\""
            end
            if(!@params['event_req_rank'].nil? && !(@params['event_req_rank'].to_i == 0))
              if(req.length > 2)
                req += ","
              end
              req += "\"rank\":"
              req += "\"" +@params['event_req_rank_operator']
              req += @params['event_req_rank'] + "\""
            end
            if(!@params['event_req_gold'].nil? && !(@params['event_req_gold'].to_i == 0))
              if(req.length > 2)
                req += ","
              end
              req += "\"gold\":"
              req += "\"" + @params['event_req_gold_operator']
              req += @params['event_req_gold'] + "\""
            end
            req += "}"
            req
          end
          #turns hp, exp, and gold into the JSON required for result
          def createDirectJSON
            result = "{"
            if(!@params['hp'].nil? && !(@params['hp'].to_i == 0))
              result += "\"hp\":"
              result += @params['hp'] 
            end
            if(!@params['exp'].nil? && !(@params['exp'].to_i == 0))
              if(result.length > 2)
                result += ","
              end
              result += "\"exp\":"
              result += @params['exp'] 
            end
            if(!@params['gold'].nil? && !(@params['gold'].to_i == 0))
              if(result.length > 2)
                result += ","
              end
              result += "\"gold\":"      
              result += @params['gold']
            end
            result += "}"
            result
          end
end 
end  