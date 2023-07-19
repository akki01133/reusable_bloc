import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:reusable_bloc/reusable_bloc.dart';

abstract class Failure extends Equatable{
  const Failure();
  @override
  List<Object?> get props => [];
}

class TextFailure extends Failure{
  const TextFailure();
}

class TextBloc extends DataBloc<String> {
  TextBloc() : super(DataUninitialized());

  @override
  Future<Either<Failure, String>> fetchAndParseData<Failure>(DataState<String> oldState, FetchData event) async {
    return Right('Hello World');
  }
}

void main() {

  final bloc = TextBloc();
  bloc.add(FetchData<String>());
  bloc.stream.listen((event) {
    print(event);
  });
}
