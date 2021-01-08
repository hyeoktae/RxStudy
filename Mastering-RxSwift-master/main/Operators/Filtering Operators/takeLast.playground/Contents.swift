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
 # takeLast
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


let subject = PublishSubject<Int>()

subject.takeLast(2)
  .subscribe {print($0)}
  .disposed(by: disposeBag)

numbers.forEach {
  subject.onNext($0)
}

// 위 코드까지 결과는 아무것도 안나온다. 하지만 코드는 작동했다. takeLast는 마지막에 방출한 9, 10을 버퍼에 저장하고 있다.

subject.onNext(11)

// 이러면 버퍼에 저장되어있는 9, 10이 -> 10, 11로 업데이트 된다.
// 아직은 옵져버블이 다른요소를 방출할지 아니면 종료할지 판단할수 없어서 요소를 방출하는 시점을 계속 지연시킨다.

//subject.onCompleted()

// 컴플리티드 이벤트를 전달하면, 이때 버퍼에 저장되었던 요소가 구독자에게 전달되고, 그 후 컴플리티드 이벤트가 전달된다.

enum MyError: Error {
  case error
}

subject.onError(MyError.error)

// 에러가 전달되면 버퍼에 있는 요소는 전달되지 않고, 에러만 전달된다.

// 정수를 파람으로 받아서 옵져버블을 리턴한다. 리턴되는 옵져버블에는 원본옵져버블이 방출하는 요소중에서 마지막에 방출된 n개의 요소가 포함된다. 이 연산자에서 가장 중요한것은 구독자로 전달되는 시점이 딜레이된다는 것!



