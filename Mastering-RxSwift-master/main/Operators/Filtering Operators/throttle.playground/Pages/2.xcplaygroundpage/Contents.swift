//: [Previous](@previous)

//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

/*:
 # throttle
 ## latest parameter
 */

let disposeBag = DisposeBag()

// 두번째 파람값에 따른 결과 비교

func currentTimeString() -> String {
  let f = DateFormatter()
  f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
  return f.string(from: Date())
}


//Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//  .debug()
//  .take(10)
//  .throttle(.milliseconds(2500), latest: true, scheduler: MainScheduler.instance)
//  .subscribe { print(currentTimeString(), $0) }
//  .disposed(by: disposeBag)
// 두번째 파람을 true로 한다면, 주기를 정확히 지킨다.

/*
 2021-01-12 00:51:58.751: 2.xcplaygroundpage:45 (__lldb_expr_77) -> subscribed
 2021-01-12 00:51:59.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(0)
 2021-01-12 00:51:59.775 next(0)
 2021-01-12 00:52:00.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(1)
 2021-01-12 00:52:01.775: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(2)
 2021-01-12 00:52:02.278 next(2)
 2021-01-12 00:52:02.775: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(3)
 2021-01-12 00:52:03.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(4)
 2021-01-12 00:52:04.775: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(5)
 2021-01-12 00:52:04.780 next(5)
 2021-01-12 00:52:05.775: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(6)
 2021-01-12 00:52:06.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(7)
 2021-01-12 00:52:07.281 next(7)
 2021-01-12 00:52:07.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(8)
 2021-01-12 00:52:08.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(9)
 2021-01-12 00:52:08.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> isDisposed
 2021-01-12 00:52:09.782 next(9)
 2021-01-12 00:52:09.783 completed
 */

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
   .debug()
   .take(10)
   .throttle(.milliseconds(2500), latest: false, scheduler: MainScheduler.instance)
   .subscribe { print(currentTimeString(), $0) }
   .disposed(by: disposeBag)
// 구독자로 전달된 첫번째와 2번째를 시간을 비교하면 3초이다. 넥스트이벤트가 방출되고 지정된 주기가 지나고 그 이후에 첫번째로 방출되는 넥스트이벤트를 전달한다. 첫번째 넥스트이벤트는 구독자에게 바로 전달된다. 이어서 원본옵져버블이 1과 2를 방출하고 0.5초후에 주기가 끝나는데 두번째 파람으로 true를 줬다면 마지막에 방출된 넥스트 이벤트가 구독자에게 전달되었겠지만, 이번에는 false라서 원본옵져버블이 새로운 넥스트이벤트를 방출할 때 까지 기다린다. 0.5초뒤 3이라는 넥스트이벤트가 나타다면 3을 구독자에게 전달한다.
// 지정된 주기동안 하나의 넥스트이벤트만 전달하는건 다르지 않다. 차이는 넥스트이벤트가 구독자로 전달되는 주기이다. true면 주기를 엄격히 지키지만, false라면 지정된 주기를 초과할 수 있다.

/*
 2021-01-12 01:01:39.227: 2.xcplaygroundpage:74 (__lldb_expr_92) -> subscribed
 2021-01-12 01:01:40.230: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(0)
 2021-01-12 01:01:40.231 next(0)
 2021-01-12 01:01:41.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(1)
 2021-01-12 01:01:42.228: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(2)
 2021-01-12 01:01:43.228: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(3)
 2021-01-12 01:01:43.228 next(3)
 2021-01-12 01:01:44.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(4)
 2021-01-12 01:01:45.228: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(5)
 2021-01-12 01:01:46.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(6)
 2021-01-12 01:01:46.230 next(6)
 2021-01-12 01:01:47.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(7)
 2021-01-12 01:01:48.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(8)
 2021-01-12 01:01:49.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(9)
 2021-01-12 01:01:49.230 next(9)
 2021-01-12 01:01:49.231 completed
 2021-01-12 01:01:49.231: 2.xcplaygroundpage:74 (__lldb_expr_92) -> isDisposed
 */
