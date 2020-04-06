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
    l=(100*m).to_i
    maxhp=(100+(10*(level-1))).to_i
    hp=hp.to_f
    hpper=((hp/maxhp)*100).to_i
    hp=hp.to_i
    e=e.to_f
    expp=((e/l)*100).to_i
    e=e.to_i
    return {"level"=>level,"exp"=>e,"exp_left"=>l,"maxhp"=>maxhp,"hp%"=>hpper,"exp%"=>expp}
  end
end
