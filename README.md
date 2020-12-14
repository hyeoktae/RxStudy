# RxStudy

rx를 사용하는 이유
기존코드에 비해 많이 단순해진다.

### rx 설치가 되었는지 확인
```swift
let disposeBag = DisposeBag()

Observable.just("Hello, RxSwift!")
  .subscribe { print($0) }
  .disposed(by: disposeBag)
  ```
  
### 명령형 코드와 반응형 코드의 차이
