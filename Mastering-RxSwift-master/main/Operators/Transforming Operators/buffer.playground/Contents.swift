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
 # buffer
 */

let disposeBag = DisposeBag()

// buffer -> 특정주기동안 옵져버블이 방출하는 항목을 수집 후, 하나의 배열로 리턴
// 이런 동작을 RxSwift에서 Controlled Buffering이라고한다.

// 3개의 파람,
// 1 항목을 수집할 시간 (시간이 경과하지 않아도 항목배출가능)
// 2 수집할 항목의 숫자 최대숫자가 차지 않아도 항목배출가능
// 3 스케쥴러
// 리턴 타입파라미터가 배열로 선언되어있다. 지정된 시간동안 수집한 항목을 배열에 담아 리턴한다.
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
  .buffer(timeSpan: .seconds(5), count: 3, scheduler: MainScheduler.instance)
  .take(5) // 이게 없다면 무한정 방출
  .subscribe {print($0)}
  .disposed(by: disposeBag)
// 버퍼연산자는 첫번째 파람으로 전달한 타임스팬이 경과하면 수집된 항목들을 즉시 방출한다.
// 두번째 파람으로 지정한 수만큼 수집되지 않아도 즉시방출한다.

