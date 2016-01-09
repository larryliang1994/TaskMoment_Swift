//
//  PrDelegate.swift
//  Networking
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation

protocol PrDelegate{
    func onPreExecute()
    func onPostExecute(response: String)
}