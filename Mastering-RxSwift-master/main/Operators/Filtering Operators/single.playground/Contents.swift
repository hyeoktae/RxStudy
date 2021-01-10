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
 # single
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 원본 옵져버블에서 첫번째 요소만 방출하거나 조건과 일치하는 첫번째 요소만 방출한다.
// 하나의 요소만 방출을 허용, 2개이상의 요소가 방출되면 애러를 방출한다.

Observable.just(1)
  .single()
  .subscribe { print($0) }
  .disposed(by: disposeBag)

Observable.from(numbers)
  .single()
  .subscribe { print($0) }
  .disposed(by: disposeBag)

// 요소가 방출되는건 동일하지만, 컴플리티드가 아닌 에러이벤트가 전달된다.
// error(Sequence contains more than one element.)
// 단 하나의 요소가 방출되어야 정상적으로 종료된다.

Observable.from(numbers)
  .single { $0 == 3 }
  .subscribe { print($0) }
  .disposed(by: disposeBag)
 
// 배열에 3이 한개뿐이라 최종적으로 3이 하나만 방출되고 바로 컴플리티드 이벤트가 전달된다.
// 하나의 요소만 나온다는걸 보장한다. 배열에 3이 두개라면 애러가 난다.

let subject = PublishSubject<Int>()

subject.single()
  .subscribe { print($0) }
  .disposed(by: disposeBag)

subject.onNext(100)

// 새로운 이벤트가 방출되면 바로 구독자에게 전달한다. 하나의 요소가 전달 된 후, 바로 컴플리트가 전달되는건 아니다.
// 다른 요소가 방출될수도 있으니까 대기한다. 싱글연산자가 리턴하는 옵져버블은 원본 옵져버블에서 컴플리티드 이벤트를 전달 할 때 까지 대기한다. 컴플리티드 이벤트가 전달된 시점에 하나의 요소만 방출된 시점이라면 구독자에게 컴플리티드를 방출하고, 두개이상이라면 구독자에게 에러를 방출한다. 이런식으로 작동하며, 하나의 요소만 방출되는것을 보장한다. 
