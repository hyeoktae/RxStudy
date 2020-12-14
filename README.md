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
값이나 상태의 변화에 따라 새로운 결과를 도출하는 코드를 쉽게 가능
이런게 반응형 프로그래밍이라고함

```swift
let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

Observable.combineLatest(a, b) {$0 + $1}
  .subscribe(onNext: {print($0)}) // 3
  .disposed(by: disposeBag)

a.onNext(12) // 14
```

### Observables and Observers

Observable 은 Observer에게 이벤트를 전달
Observer는 Observable을 Subscribe한다.

옵져버블은 3가지 이벤트 전달
Next: Emission(방출, 배출) 값을 포함할수 있다.
Error, Completed: Notification, 이게 나오면 라이프사이클 종료, 이후에 다른 이벤트를 전달 할수없다. 

### 옵져버블 생성 방법

1. 
```swift
Observable<Int>.create { (observer) -> Disposable in
  observer.on(.next(0))
  observer.onNext(1)
  
  observer.onCompleted()
  
  return Disposables.create()
}
```

2. 
```swift
Observable.from([0, 1])
```

2개의 정수를 순서대로 방출하고 종료하는 옵져버블이다. 정의만 했지 아무작업도 안했다. 구독을 안했기 때문이다.


### 옵져버

```swift
let o1 = Observable<Int>.create { (observer) -> Disposable in
  observer.on(.next(0))
  observer.onNext(1)
  
  observer.onCompleted()
  
  return Disposables.create()
}
```
옵져버블 생성

1. 
```swift
o1.subscribe {
  print($0)
  
  if let elem = $0.element {
    print(elem)
  }
} // 이 클로저가 옵져버
```

2. 
```swift
o1.subscribe(onNext: <#T##((Int) -> Void)?##((Int) -> Void)?##(Int) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
```

```swift
o1.subscribe(onNext: { elem in
  print(elem)
})
```
onNext만 사용했다. 옵셔널 바인딩 할 필요없다.
여러 이벤트를 동시에 전달하지 않는다. 
*하나의 이벤트가 실행된 후, 그다음 다음이벤트가 방출된다.*


### Disposables
리소스 해제할때 사용하는것.
subscribe가 리턴하는게 Disposable인데 이걸 Subscription Disposable이라고함
리소스해제, 실행취소에 사용됨.

```swift
let subscription1 = Observable.from([0, 1, 3])
  .subscribe { (elem) in
    print("Next", elem)
  } onError: { (error) in
    print("Error", error)
  } onCompleted: {
    print("Completed")
  } onDisposed: {
    print("Disposed")
  }
```

disposed되는 시점에 뭘 해야한다면 이렇게 사용한다.

```swift
subscription1.dispose() // 직접 취소하는 방법이다.
```

```swift
var bag = DisposeBag()

Observable.from([1,2,3])
  .subscribe {
    print($0)
  }
  .disposed(by: bag)
```

disposed가 되는 시점에 할게 없다면 이렇게 쓴다.
이 방법으로 dispose하는게 좋다. 공식문서에 이렇게 나온다고함.

```swift
bag = DisposeBag()
```
직접 해제 하고싶을때 이렇게 함, nil able하게 bag을 만들고 nil을 넣어줘도 된다고함


```swift 
let subscription2 = Observable<Int>.interval(.seconds(1),
                                             scheduler: MainScheduler.instance)
  .subscribe { (elem) in
    print("Next", elem)
  } onError: { (error) in
    print("Error", error)
  } onCompleted: {
    print("Completed")
  } onDisposed: {
    print("Disposed")
  }

// 위 함수는 1초마다 1씩 증가하는 정수를 방출하는데, 무한정 방출한다. 그렇기에 Dispose가 필요하다.

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
  subscription2.dispose() // 이러면 즉시 리소스가 해제되기때문에 completed가 나오지 않고 종료된다. 이 방법은 가능하면 피해야한다.
}
```



### Operators
연산자

연산자는 보통 subscribe앞에 호출한다.

```swift
let bag = DisposeBag()

Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
  .filter { $0.isMultiple(of: 2) } // 짝수만 필터
  .take(5) // 처음 5개의 요소만 전달한다.
  .subscribe { print($0) }
  .disposed(by: bag)

// 순서가 매우 중요하다. 호출순서에 따라 다른결과가 나오기때문에 호출순서를 중요하게 생각해야한다.
```
filter를 먼저하면 2,4,6,8 이고, take를 먼저하면 2,4 가 나온다. 


### Subject
옵저버는 하나의 옵저버블만 구독하고, 마찬가지로 옵저버블도 하나의 옵저버에 값을 전달할수있다.
옵저버인 동시에 옵저버블이다. 

publishSubject: 서브젝트로 전달되는 새로운 이벤트를 구독자에게 전달한다.
BehaviorSubject: 생성시점에 시작이벤트를 지정한다. 서브젝트로 전달되는 이벤트중에 가장마지막의 이벤트를 저장했다가, 새로운 구독자에게 마지막에 저장된 이벤트를 준다.
ReplaySubject: 처음부터 모든 이벤트를 저장한다. 그러고 새로운 구독자가 나타나면 저장했던 모든 이벤트를 준다.
AsyncSubject: subject로 completed가 전달되는 시점에 마지막 이벤트를 구독자에게 전달한다.

PublishRelay: PublishSubject를 랩핑한것
BehaviorRelay: BehaviorSubject를 랩핑한것
Relay는 completed, error는 받지 않고, next 이벤트만 받는다.
주로 종료없이 계속 전달되는 이벤트 시퀀스를 다룰때 사용한다. 

### PublishSubject
서브젝트로 전달되는 이벤트를 옵저버에 전달하는 가장 기본적인 subject이다.

```swift
let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = PublishSubject<String>() // 내부에 아무런 이벤트가 없다.

subject.onNext("Hello") // 구독자가 없으면 이 이벤트는 그냥 사라진다.

let o1 = subject.subscribe { print(">> 1", $0) }
o1.disposed(by: disposeBag) // 구독하기 전 이벤트는 아무소용이 없다. publish는 (저장안해서)

subject.onNext("RxSwift")

let o2 = subject.subscribe { print(">> 2", $0) }
o2.disposed(by: disposeBag)

subject.onNext("Subject")

//subject.onCompleted()
subject.onError(MyError.error)

let o3 = subject.subscribe { print(">> 3", $0) } // 이미 completed가 되었기때문에 (종료됨) 바로 completed가 된다.
o3.disposed(by: disposeBag) // 이 전에 error가 나왔기때문에 바로 error가 된다.
// 만약 이전의 이벤트들을 저장하고 싶으면, replays 나 cold observable을 사용해야한다.
```

### BehaviorSubject

```swift
let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// publish랑 비슷하지만, 서브젝트를 생성하는 방식에 차이가 있다.

let p = PublishSubject<Int>() // 이벤트가 없는채로 생성
p.subscribe { print("PublishSubject >>", $0) }
  .disposed(by: disposeBag)

let b = BehaviorSubject<Int>(value: 0) // 초기이벤트가 있는채로 생성 0인이유는 제네릭타임이 Int로 정해졌기때문이다. 새로운 구독자가 생성되면 바로 저장되어있는 초기 이벤트값이 전달된다.
b.subscribe { print("BehaviorSubject >>", $0) } // BehaviorSubject >> next(0)
  .disposed(by: disposeBag)

b.onNext(1)
 
b.subscribe { print("BehaviorSubject2 >>", $0) } // BehaviorSubject >> next(1) 결론적으로 보면 마지막 이벤트를 새로운구독자에게 전달을 하는것.
  .disposed(by: disposeBag)

//b.onCompleted()
b.onError(MyError.error)


b.subscribe { print("BehaviorSubject3 >>", $0) } // 이미 completed가 되어서(종료) 얘도 바로 completed가 된다. err도 마찮가지이다.
  .disposed(by: disposeBag)
```
