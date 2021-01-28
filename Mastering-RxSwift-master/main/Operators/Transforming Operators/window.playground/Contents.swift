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
 # window
 */

let disposeBag = DisposeBag()

// window: buffer 연산자처럼 타임스팬과 맥스카운트를 지정해서 원본옵져버블이 방출하는 항목들을 작은단위의 옵져버블로 분해한다.
// 버퍼연산자는 수집된 항목을 배열형태로 리턴하지만 윈도우는 수집된 항목을 방출하는 옵져버블을 리턴한다.
// 그래서 리턴된 옵져버블이 뭘 방출하고 언제 완료되는지 이해하는것이 중요하다.

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
  .window(timeSpan: .seconds(5), count: 3, scheduler: MainScheduler.instance)
  .take(5)
  .subscribe {
    print($0)
    if let observable = $0.element {
      observable.subscribe { print(" inner: ", $0) }
        .disposed(by: disposeBag)
    }
  }
  .disposed(by: disposeBag)


// 파람은 버퍼와 비슷. 1. 항목을 분해할 시간단위 2. 분해할 최대 항목수 3. 연산자를 실행할 스케쥴러 전달
// 리턴형이 버퍼와 다르다. 옵져버블을 방출하는 옵져버블을 리턴한다. 이것을 Inner Observable이라고 한다.
// 이것은 지정된 최대항목수만큼 방출하거나, 지정된 시간이 경과하면 컴플리티드를 전달하고 종료한다.
// RxSwift.AddRef -> 특별한 형태의 옵져버블 Inner Observable, 이것을 구독할수있다는걸 이해하는거로 충분
// 시간의 오차로 결과가 상이할 수 있다.
// 시간이 차지 않아도 maxCount가 차면 바로 방출한다.

/*
 next(RxSwift.AddRef<Swift.Int>)
  inner:  next(0)
  inner:  completed
 next(RxSwift.AddRef<Swift.Int>)
  inner:  next(1)
  inner:  next(2)
  inner:  next(3)
  inner:  completed
 next(RxSwift.AddRef<Swift.Int>)
  inner:  next(4)
  inner:  next(5)
  inner:  completed
 next(RxSwift.AddRef<Swift.Int>)
  inner:  next(6)
  inner:  next(7)
  inner:  completed
 next(RxSwift.AddRef<Swift.Int>)
 completed
  inner:  next(8)
  inner:  next(9)
  inner:  completed

 */
