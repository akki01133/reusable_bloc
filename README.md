<?code-excerpt path-base="example/lib"?>

[![pub package](https://img.shields.io/pub/v/reusable_bloc.svg)](https://pub.dev/packages/reusable_bloc)

Generic Refreshable Data Blocs which are easily extendible to fetch data from network

## Features

1. implement whole bloc by extending the `DataBloc` class and overriding the fetch data function
2. implements optionally to refresh the data, calling the fetch the data again
3. remembers the previous data when on refresh error and rollback to `DataLoaded` State again
4. uses `Equatable` class from `equatable` package to add comparison of the state class
5. the fetch data function returns `Either<Failure,Data>` from `dartz` package, making it fully compatible with **clean-architecture**
## Getting started

1. This generic bloc package is an extended and flexible version from this [blog-part1](https://itnext.io/flutter-blocs-at-scale-1-the-state-machine-fce5f086d7b9) and [blog-part2](https://itnext.io/flutter-blocs-at-scale-2-keeping-blocs-lean-1b659536e3ec). If you want to learn bloc as a state machine, head on to this blog.

## Usage

```dart
class GreetBloc extends DataBloc<String> {
  GreetBloc() : super(DataUninitialized());

  @override
  Future<Either<Failure, String>> fetchAndParseData<Failure>(
      DataState<String> oldState, FetchData event) async{
    final p = event.param as GreetFetchParam;
    await Future.delayed(Duration(seconds:2)); // network call place holder
    return Right(p.name);
  }
}


/// [FetchParam] is a class that holds the optional parameters for the [FetchData] event.
class GreetFetchParam extends FetchParam {
  final String name;
  const GreetFetchParam(this.name);

  @override
  List<Object?> get props => [name];
}

void main() {
  final bloc = GreetBloc();
  bloc.add(FetchData<String>(GreetFetchParam('ajeet')));
  bloc.stream.listen((event) {
    print(event);
  });
}
```

## Additional information

You liked this package? then hit a like. I don't want you to buy me a coffee. Just use this package if you feel the need. And if you need a feel... contribute and let's make something better together.

1. Star this repository
2. Create a Pull Request with new features
3. Share this package
4. Create issues if you find a Bug or want to suggest something
