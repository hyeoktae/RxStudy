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
 # toArray
 */

let disposeBag = DisposeBag()

// 옵져버블이 방출하는 모든 요소를 배열에 담고, 이 배열을 방출하는 옵져버블을 생성한다.

let subject = PublishSubject<Int>()

subject
  .toArray()
  .subscribe { print($0) }
  .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)
subject.onCompleted()

// toArray -> 파람 없다. 리턴값: 싱글
// 소스 옵져버블이 방출하는 모든요소를 하나의 배열에 담는다. 소스옵져버블이 더이상 요소를 방출하지 않는 시점이되야 모아둔 배열을 방출한다. completed하면 요소들을 모아둔 배열을 방출한다. 
