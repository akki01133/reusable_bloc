import 'package:dartz/dartz.dart';
import 'package:reusable_bloc/reusable_bloc.dart';
import 'package:reusable_bloc/src/reusable_bloc_sync.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

///==============================================================
/// Example of [DataBlocSync]
/// [DataBlocSync] is a [Bloc] that handles the data fetching and
/// parsing synchronously.
///==============================================================
class GreetBloc extends DataBloc<Failure, String> {
  GreetBloc() : super(DataUninitialized());

  @override
  Future<Either<Failure, String>> fetchAndParseData(
      DataState<String> oldState, FetchData event) async {
    final p = event.param as GreetFetchParam;
    await Future.delayed(Duration(seconds: 2)); // network call place holder
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
