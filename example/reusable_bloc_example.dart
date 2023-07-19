import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:reusable_bloc/reusable_bloc.dart';
import 'package:reusable_bloc/src/reusable_bloc_sync.dart';

abstract class Failure extends Equatable {
  const Failure();
  @override
  List<Object?> get props => [];
}

class TextFailure extends Failure {
  const TextFailure();
}

class TextBloc extends DataBlocSync<String> {
  TextBloc() : super(DataUninitialized());

  @override
  Either<Failure, String> fetchAndParseDataSync<Failure>(
      DataState<String> oldState, FetchDataSync event) {
    final p = event.param as TextFetchParam;
    return Right(p.text);
  }
}

class TextFetchParam extends FetchParam {
  final String text;
  const TextFetchParam(this.text);

  @override
  List<Object?> get props => [text];
}

void main() {
  final bloc = TextBloc();
  bloc.add(FetchDataSync<String>(TextFetchParam('hello ajeet')));
  bloc.stream.listen((event) {
    print(event);
  });
}
