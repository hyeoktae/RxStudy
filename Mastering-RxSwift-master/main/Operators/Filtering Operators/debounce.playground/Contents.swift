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
 # debounce
 */

let disposeBag = DisposeBag()

// debounce와 throttle은 짧은시간동안 반복적으로 방출되는 이벤트를 제어한다는 공통점이 있다.
// 연산자로 전달하는 파람도 동일하다. 하지만 연산의 결과는 다르다.

// debounce -> 두개의 파람을 받는다.
// 1. 시간을 전달한다. 이시간은 연산자가 넥스트이벤트를 방출할지 결정하는 조건으로 사용된다. 옵져버가 넥스트를 방출한 후, 지정된 시간동안 다른 넥스트이벤트를 방출하지 않는다면, 해당 시점에 가장마지막으로 방출된 넥스트이벤트를 구독자에게 전달한다. 반대로 지정된 시간 이내에 또다른 넥스트가 방출된다면, 타이머를 초기화한다. 이부분을 이해하는게 정말 중요하다.
// 2. 타이머를 실행할 스케쥴러를 전달한다.

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
  
  return Disposables.create {
    
  }
}

buttonTap
  .debounce(.milliseconds(499), scheduler: MainScheduler.instance)
  .subscribe { print($0) }
  .disposed(by: disposeBag)

// .milliseconds(1000) [1초] 를 넣으면 10, 20 나오고 컴플리트
// .milliseconds(400) [0.4초] 를 넣으면 10, 11, 12...20 후 컴플리트, 설정한 0.5초보다 짧기때문이다.
