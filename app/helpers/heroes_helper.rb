module HeroesHelper
  def hero_update(par,hero)
    par.keys.each{
      |r|
        if r=="exp"
          puts "exp"
          og=stats_calc(hero.exp,hero.hp)
          after=(r=="exp")?stats_calc(hero.exp+par['exp'],hero.hp):og
          if og['level']<after['level']
            puts hero.hp
              hero.hp+=(after['maxhp']-og['maxhp'])
              puts hero.hp           
          end
        elsif r=="hp"
          puts "hp"
          puts hero.hp
          og=stats_calc(hero.exp,hero.hp)
          puts og['maxhp']
          puts (par['hp'].to_i+hero.hp)
          hero.hp=((par['hp'].to_i+hero.hp)>og['maxhp'])?og['maxhp']:(par['hp'].to_i+hero.hp)
          puts hero.hp
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
end
