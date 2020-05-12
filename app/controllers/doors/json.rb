module Doors
    class Json

        attr_accessor :params
        def initialize(params)
            @params = params
        end

        def createResultJSON
            result = "{"
            if(!@params['door_result_hp'].nil? && !(@params['door_result_hp'].to_i == 0))
                result += "\"hp\":"
                result += @params['door_result_hp'] 
            end
    
            if(!@params['door_result_exp'].nil? && !(@params['door_result_exp'].to_i == 0))
                if (result.length > 2)
                    result +=","
                end
                result += "\"exp\":"
                result += @params['door_result_exp'] 
                end
            if(!@params['door_result_gold'].nil? && !(@params['door_result_gold'].to_i == 0)) 
                if (result.length > 2)
                    result +=","
                end
                result += "\"gold\":"
                result += @params['door_result_gold']
            end
        result += "}"
        end
    def createRequirementJSON
        req = "{"
        if(!@params['door_req_hp'].nil? && !(@params['door_req_hp'].to_i == 0))
            req += "\"hp\":"
            req += "\"" + @params['door_req_hp_operator'].to_s
            req += @params['door_req_hp'] + "\""
        end
        if(!@params['door_req_rank'].nil? && !(@params['door_req_rank'].to_i == 0))
            if(req.length > 2)
                req += ", "
            end
            req += "\"rank\":"
            req += "\"" +@params['door_req_rank_operator']
            req += @params['door_req_rank'] + "\""
        end
        if(!@params['door_req_gold'].nil? && !(@params['door_req_gold'].to_i == 0))
            if(req.length > 2)
                req += ","
            end
            req+= "\"gold\":"
            req += "\"" + @params['door_req_gold_operator']
            req += @params['door_req_gold'] + "\""
        end
        req += "}"
        req
    end
end 
end  