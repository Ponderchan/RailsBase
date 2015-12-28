class GameController < ApplicationController
  layout false
  # 中奖概率计算方法
  def lottery_random
    chance = set_chance

    lottery_result = {}
    # 当前用于计算的随机数最大值,每次循环做递减，保证一定有奖项
    current_max_chance = 100
    chance.each do |item|
      tem_rate = rand(current_max_chance)
      if tem_rate<=item[:rate]
        lottery_result = item
        break
      else
        current_max_chance = current_max_chance-item[:rate]
      end
    end

    render json: lottery_result.as_json
  end

  private
  # 设置每一个奖项的中奖概率，手动设置测试用。实际开发的时候 概率需要管理后台用户自行设置
  def set_chance
    chance = []

    # 用于计算最后一个奖项的概率
    sum_hit = 0
    (1..4).each do |i|
      # label   奖品信息
      # rate    中奖概率
      # lev     奖品等级
      item = {}
      case i
        when 1
          item[:label] = '一等奖'
          item[:rate] = 1
          item[:lev] = 1
        when 2
          item[:label] = '二等奖'
          item[:rate] = 15
          item[:lev] = 2
        when 3
          item[:label] = '三等奖'
          item[:rate] = 30
          item[:lev] = 3
        when 4
          item[:label] = '四等奖'
          item[:rate] = 100-sum_hit
          item[:lev] = 4
        else
      end

      sum_hit = sum_hit+ item[:rate]

      chance.push item
    end
    p chance
    return chance
  end

end
