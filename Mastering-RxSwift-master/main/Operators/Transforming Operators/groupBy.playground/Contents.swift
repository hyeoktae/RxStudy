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
 # groupBy
 */

let disposeBag = DisposeBag()
let words = ["Apple", "Banana", "Orange", "Book", "City", "Axe"]

// 옵져버블이 방출하는 요소를 원하는기준으로 그룹핑할때 사용한다.
// 파라미터로 클로져를 받고, 클로져는 요소를 파라미터로 받아서 키를 리턴한다.
// 키의 형식은 Hashable 프로토콜을 채용한 형식으로 한정되어있다.
// 연산자를 실행하면 클로져에서 동일한 값을 리턴하는 요소끼리 그룹으로 묶이고
// 그룹에 속한 요소들은 개별 옵져버블을 통해 방출된다.
// 연산자가 리턴하는 옵져버블은 타입파라미터가 GroupedObservable로 선언되있다.
// 여기에는 방출하는 요소와 함께 키가 저장되어 있다.

// 문자열 기준으로 그룹핑 해본다.

Observable.from(words)
  .groupBy { $0.count } // 이러면 키 형태가 Int가 된다. 문자열 길이에 따라 그룹핑
  .subscribe(onNext: { groupedObservable in
    print("== \(groupedObservable.key)")
    groupedObservable.subscribe { print(" \($0)") }
      .disposed(by: disposeBag)
  })
  .disposed(by: disposeBag)

// 그룹바이 연산자를 사용할때는 보통 flatMap와 toArray연산자를 활용해서
// 그룹핑된 최종결과를 하나의 배열로 방출하도록 구현한다.

Observable.from(words)
  .groupBy { $0.count }
  .flatMap { $0.toArray() }
  .subscribe { print($0) }
  .disposed(by: disposeBag)


// 이번에는 첫번째 문자를 기준으로 그룹핑 해본다.

Observable.from(words)
  .groupBy { $0.first ?? Character(" ") }
  .flatMap { $0.toArray() }
  .subscribe { print($0) }
  .disposed(by: disposeBag)

// 홀수과 짝수로 나눠보기 도전과제
Observable.range(start: 1, count: 10)
  .groupBy { $0 % 2 }
  .flatMap { $0.toArray() }
  .subscribe { print($0) }
  .disposed(by: disposeBag)
