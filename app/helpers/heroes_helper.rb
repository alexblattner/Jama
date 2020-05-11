module HeroesHelper
  def hero_update(par,hero)
    par.keys.each{
      |r|
        if r=="exp"
          og=stats_calc(hero.exp,hero.hp)
          after=(r=="exp")?stats_calc(hero.exp+par['exp'],hero.hp):og
          if og['rank']<after['rank']
            hero.hp+=(after['maxhp']-og['maxhp'])
          elsif og['rank']>after['rank']
            hero.hp=(after['maxhp']>og['hp'])?after['maxhp']:og['hp']
          end
        elsif r=="hp"
          og=stats_calc(hero.exp,hero.hp)
          hero.hp=((par['hp'].to_i+hero.hp)>og['maxhp'])?og['maxhp']:(par['hp'].to_i+hero.hp)
        end
        if r!="hp"
          hero[r]=hero[r]+par[r]
          if hero[r]<0
            hero[r]=0
          end
        end
        
    }
    hero.save
  end
  def requirements_passed(hero,re)
    passed=true
    re.keys.each{
      |i|
      s=re[i]
      if s[0]==">"
        s[0]=''
        t=(['exp','hp','gold'].include?i)?hero:stats_calc(hero.exp,hero.hp)
        if t[i]<=s.to_i
          passed=false
        end
      elsif s[0]=="="
        s[0]=''
        t=(['exp','hp','gold'].include?i)?hero:stats_calc(hero.exp,hero.hp)
        if t[i]<=s.to_i
          passed=false
        end
      elsif s[0]=="<"
        s[0]=''
        t=(['exp','hp','gold'].include?i)?hero:stats_calc(hero.exp,hero.hp)
        if t[i]>=s.to_i
          passed=false
        end
      end
    }
    return passed
  end
  def stats_calc(exp,hp)
    if exp>0
      e=exp
    else
      e=0
    end
    m=1
    level=1
    while e>=(100*m)
      e-=100*m
      m=m*2
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
    return {"rank"=>level,"exp"=>e,"exp_left"=>l,"maxhp"=>maxhp,"hp%"=>hpper,"exp%"=>expp,"hp"=>hp}
  end
end
