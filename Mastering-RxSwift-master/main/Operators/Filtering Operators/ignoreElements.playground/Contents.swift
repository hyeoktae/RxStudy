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
 # ignoreElements
 */

let disposeBag = DisposeBag()
let fruits = ["🍏", "🍎", "🍋", "🍓", "🍇"]


// 옵져버블이 방출하는 넥스트 이벤트를 필터링하고 컨플리티드, 에러 이벤트만 구독자에게 전달한다.

Observable.from(fruits)
  .ignoreElements()
  .subscribe {print($0)}
  .disposed(by: disposeBag)
// ignoreElements() -> param받지않음. 리턴형은 Completable. 이건 트레이치 라고 불리는 특별한 옵져버블이다. 컴플리티드나 에러만 전달하고 넥스트는 무시한다. 작업의 성공과 실패에만 관심이 있을 때 사용한다.
// ignoreElements가 필터링 하기 때문에 next가 무시된다.











