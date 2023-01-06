//
//  Lx.swift
//  Me LX Bill
//
//  Created by Yazz Tanaka on 26/12/2022.
//

import Foundation

/*
MY RATES:
basicRate = 1364.0
  limit_1 = 120.0
   rate_1 = 23.97
  limit_2 = 280.0
   rate_2 = 30.26
   rate_3 = 33.98
      fee = 3.66
     levy = 3.45

  minRate = 250.80
 */

struct Lx {
    var basicRate: Double
    var limit_1: Double
    var limit_2: Double
    var rate_1: Double
    var rate_2: Double
    var rate_3: Double
    var fee: Double // Fuel cost adjustment fee
    var levy: Double // Renewable energy generation levy
}

func Calculate(basicRate: Double, limit_1: Double, limit_2: Double, rate_1: Double, rate_2: Double, rate_3: Double, fee: Double, levy: Double, kwh: Double) -> Int {
    
    var sumOfRate_1 = 0.0   // kwh * rate_1
    var sumOfRate_2 = 0.0   // kwh * rate_2
    var sumOfRate_3 = 0.0   // kwh * rate_3
    let sumOfFee = kwh * fee
    let sumOfLevy = floor(kwh * levy)
    var sub_total: Int = 0
    
    if (kwh == 0) {
        return 0
    } else if (kwh <= limit_1) {
        sumOfRate_1 = kwh * rate_1
        sub_total = Int(basicRate + sumOfRate_1 + sumOfFee + sumOfLevy)
        return sub_total
    } else if (kwh > limit_1 && kwh <= limit_2) {
        sumOfRate_1 = limit_1 * rate_1
        sumOfRate_2 = (kwh - limit_1) * rate_2
        sub_total = Int(basicRate + sumOfRate_1 + sumOfRate_2 + sumOfFee + sumOfLevy)
        return sub_total
    } else {
        sumOfRate_1 = limit_1 * rate_1
        sumOfRate_2 = (limit_2 - limit_1) * rate_2
        sumOfRate_3 = (kwh - limit_2) * rate_3
        sub_total = Int(basicRate + sumOfRate_1 + sumOfRate_2 + sumOfRate_3 + sumOfFee + sumOfLevy)
        return sub_total
    }
}
