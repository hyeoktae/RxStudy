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
 # flatMap
 */

let disposeBag = DisposeBag()

/*
 원본옵져버블이 항목을 방출하면, 플랫맵 연산자가 변환함수를 실행, 변환함수는 방출된항목을 옵져버블로 변환한다.
 방출된 항목의 값이 바뀌면 플랫맵연산자가 변환한 옵져버블이 새로운항목을 방출한다.
 이런특징때문에 원본옵져버블이 방출하는 항목을 지속적으로 감시하고 최신값을 확인 할 수 있다.
 플랫맵은 모든옵져버블이 방출하는 항목을 모아서, 최종적으로 하나의 옵져버블을 리턴한다.
 개별항목이 개별옵져버블로 변환되었다가 다시 하나의 옵져버블로 합쳐진다.
 */

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

let subject = PublishSubject<BehaviorSubject<Int>>()

subject.flatMap{$0 as Observable}
  .subscribe {print($0)}
  .disposed(by: disposeBag)

subject.onNext(b)
subject.onNext(a)


b.onNext(4)
a.onNext(3)

// 플랫맵 연산자는 원본옵져버블이 방출하는 항목을 새로운옵져버블로 변환한다.
// 새로운 옵져버블은 항목이 업데이트 될 때마다 새로운 항목을 방출한다.
// 이렇게 생성된 모든 옵져버블은 최종적으로 하나의 옵져버블로 합쳐지고 모든 항목들이 이 옵져버블을 통해서 구독자에게 전달된다.
// 단순이 처음에 방출된 항목만 구독자로 방출되는게 아니라, 업데이트된 최신몫도 방출된다.
// 이건 네트워크 통신할 때 자주 사용된다.
