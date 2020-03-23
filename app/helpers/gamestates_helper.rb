module GamestatesHelper
  def stats_calc(exp,hp)
    e=exp
    m=1
    level=1
    while e>(100*m)
      e-=100*m
      m=m*1.5
      level+=1
    end
    maxhp=100*m
    puts hp
    puts maxhp
    hpper=(hp/maxhp)*100
    return {"level"=>level,"exp"=>e,"maxhp"=>maxhp,"hp%"=>hpper}
  end
end
