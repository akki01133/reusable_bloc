import 'package:equatable/equatable.dart';

abstract class DataEvent<T> extends Equatable {
  const DataEvent();

  @override
  List<Object?> get props => [];
}

class FetchData<T> extends DataEvent<T> {
  final FetchParam _param;
  bool get hasParam => _param is! NoFetchParam;
  FetchParam get param => _param;
  const FetchData([FetchParam? param])
      : _param = param ?? const NoFetchParam(),super();

  @override
  List<Object?> get props => [...super.props];
}

abstract class DataEventSync<T> extends Equatable {
  const DataEventSync();

  @override
  List<Object?> get props => [];
}

class FetchDataSync<T> extends DataEventSync<T> {
  final FetchParam _param;
  bool get hasParam => _param is! NoFetchParam;
  FetchParam get param => _param;
  const FetchDataSync([FetchParam? param])
      : _param = param ?? const NoFetchParam(),
        super();

  @override
  List<Object?> get props => [...super.props];
}

///====================================================================
/// [FetchParam] is a parameter class that can be used to pass
/// parameters to both the [FetchDataSync] and [FetchData] events.
/// It is a [Equatable] class and thus can be used to compare
/// equality of two [FetchParam] objects.
/// [FetchParam] is optional and can be omitted from the [FetchDataSync]
/// and [FetchData] events.
/// ====================================================================
abstract class FetchParam extends Equatable {
  const FetchParam();
}

class NoFetchParam extends FetchParam {
  const NoFetchParam();
  @override
  List<Object?> get props => [];
}
