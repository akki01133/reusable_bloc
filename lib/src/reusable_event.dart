


import 'package:equatable/equatable.dart';

abstract class DataEvent<T> extends Equatable {
  const DataEvent();

  @override
  List<Object?> get props => [];
}

class FetchData<T> extends DataEvent<T> {
  const FetchData() : super();

  @override
  List<Object?> get props => [...super.props];
}