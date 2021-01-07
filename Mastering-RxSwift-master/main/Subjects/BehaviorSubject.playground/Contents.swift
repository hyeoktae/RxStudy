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
 # BehaviorSubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// publish랑 비슷하지만, 서브젝트를 생성하는 방식에 차이가 있다.

let p = PublishSubject<Int>() // 이벤트가 없는채로 생성
p.subscribe { print("PublishSubject >>", $0) }
  .disposed(by: disposeBag)

let b = BehaviorSubject<Int>(value: 0) // 초기이벤트가 있는채로 생성 0인이유는 제네릭타임이 Int로 정해졌기때문이다. 새로운 구독자가 생성되면 바로 저장되어있는 초기 이벤트값이 전달된다.
b.subscribe { print("BehaviorSubject >>", $0) } // BehaviorSubject >> next(0)
  .disposed(by: disposeBag)

b.onNext(1)
 
b.subscribe { print("BehaviorSubject2 >>", $0) } // BehaviorSubject >> next(1) 결론적으로 보면 마지막 이벤트를 새로운구독자에게 전달을 하는것.
  .disposed(by: disposeBag)

//b.onCompleted()
b.onError(MyError.error)


b.subscribe { print("BehaviorSubject3 >>", $0) } // 이미 completed가 되어서(종료) 얘도 바로 completed가 된다. err도 마찮가지이다.
  .disposed(by: disposeBag)

