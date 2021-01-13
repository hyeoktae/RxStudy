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
 # scan
 */

let disposeBag = DisposeBag()

// scan -> 기본값으로 연산을 시작한다.
// 원본옵져버블이 방출하는 항목을 대상으로 변환을 실행한 후,
// 결과를 방출하는 하나의 옵져버블을 리턴한다.
// 원본이 방출하는 항목의 수와 구독자로 전달되는 항목의 수가 같다.

// param 1 기본값, 2 클로져
// 클로져형식은 파람이 2개다. 첫번째는 기본값의 형식과 같고
// 두번째는 옵져버블이 방출하는 항목의 형식과 같다.
// 클로져의 리턴형은 첫번째 파람과 같다.
// 스캔연산자로 전달하는 클로져는
// Accumulator Function or Accumulator Closure라고 부른다.
// 기본값이나 옵져버블이 방출하는 항목을 대상으로 Accumulator Closure 를 실행하고 결과를 옵져버블로 리턴한다.
// 클로져가 리턴한 값은 이어서 실행되는 클로져의 첫번째 파람으로 전달된다.
// 'reduce'랑 비슷하다.
Observable.range(start: 1, count: 10)
  .scan(0, accumulator: +)
  .subscribe {print($0)}
  .disposed(by: disposeBag)
// 작업결과를 누적시키면서 중간결과와 최종결과가 모두 필요할 경우 사용한다.
// 최종값만 필요하면 reduce를 사용한다.
