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
 */

let disposeBag = DisposeBag()

// debounce와 throttle은 짧은시간동안 반복적으로 방출되는 이벤트를 제어한다는 공통점이 있다.
// throttle -> 실제로는 3개의 파람을 받는다. (기본값을 가진 2번째 파람은 생략가능)
// 1. 반복주기를 전달, 3. 스케쥴러를 전달.
// 지정된 주기동안 하나의 이벤트만 구독자에게 전달한다. 보통 두번째 파람은 기본값을 사용하는데, 이때는 주기를 엄격하게 지킨다. 항상 지정된 주기마다 하나씩 이벤트를 전달한다.
// 반대로 두번째 파람에 false를 주면 반복주기가 경과한 다음, 가장 먼저 방출되는 이벤트를 구독자에게 전달한다.

let buttonTap = Observable<String>.create { observer in
  DispatchQueue.global().async {
    for i in 1...10 {
      observer.onNext("Tap \(i)")
      Thread.sleep(forTimeInterval: 0.3)
    }
    
    Thread.sleep(forTimeInterval: 1)
    
    for i in 11...20 {
      observer.onNext("Tap \(i)")
      Thread.sleep(forTimeInterval: 0.5)
    }
    
    observer.onCompleted()
  }
  
  return Disposables.create()
}


buttonTap
  .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
  .subscribe { print($0) }
  .disposed(by: disposeBag)

// .milliseconds(1000)


// throttle은 넥스트이벤트를 지정된 주기마다 하나씩 구독자에게 전달한다.
// 짧은시간동안 반복되는 탭 이벤트나 델리게이트 메시지를 처리할때 주로 사용한다.
//: [Next](@next)
