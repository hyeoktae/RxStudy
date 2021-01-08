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
 # skipUntil
 */

let disposeBag = DisposeBag()

let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.skipUntil(trigger)
  .subscribe {print($0)}
  .disposed(by: disposeBag)

subject.onNext(1)

trigger.onNext(0)

subject.onNext(2)

trigger.onNext(3)

subject.onNext(4)
// 옵져버블타입을 파람으로 받는다. 다른 옵져버블을 받는다. 이 옵져버블이 넥스트이벤트를 전달하기 전까지 원본옵져버블이 방출하는 이벤트를 무시한다. 이런 특징때문에 파라미터로 전달하는 옵져버블을 트리거라고 부르기도 한다.
// 트리거가 방출 한 후에 서브젝트가 방출을 할 수 있다.  2,4
