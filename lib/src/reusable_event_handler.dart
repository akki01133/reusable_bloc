import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:reusable_bloc/src/reusable_event.dart';
import 'package:reusable_bloc/src/reusable_state.dart';

class DataEventHandler<L, T> {
  const DataEventHandler();

  /// Handler for [FetchData] + [DataUninitialized] combination.
  /// Handles initial fetch when the  data is not yet present.
  ///
  /// On success it emits: [DataInitialFetching], [DataLoaded].
  /// On failure it emits: [DataInitialFetching], [DataInitialFetchingError], [DataUninitialized].
  Future<void> mapInitialFetchDataToState(
    FetchData<T> event,
    DataUninitialized state,
    Emitter<DataState<T>> emit,
    Future<Either<L, T>> Function(DataState<T>, FetchData<T>) fetchAndParseData,
  ) async {
    emit(DataInitialFetching());
    final res = await fetchAndParseData(state as DataState<T>, event);

    res.fold((e) {
      emit(DataInitialFetchingError(e));
      emit(DataUninitialized());
    }, (data) {
      // skipped the fetching success state
      emit(DataLoaded(data));
    });
  }

  /// Handler for [FetchData] + [DataLoaded] combination.
  /// Handles refetch of the  data.
  ///
  /// On success it emits: [DataRefetching], [DataLoaded].
  /// On failure it emits: [DataRefetching], [DataRefetchingError], [DataLoaded].
  Future<void> mapRefetchDataToState(
    FetchData<T> event,
    DataLoaded<T> state,
    Emitter<DataState<T>> emit,
    Future<Either<L, T>> Function(DataState<T>, FetchData<T>) fetchAndParseData,
  ) async {
    emit(DataRefetching(state));
    final res = await fetchAndParseData(state, event);
    final T data = res.getOrElse(() => state.data);

    res.fold((l) {
      emit(DataRefetchingError(state, l));
      emit(DataLoaded(data));
    }, (r) {
      emit(DataRefetchingSuccess(data));
      emit(DataLoaded(data));
    });
  }

  /// Handler for [FetchData] + [DataUninitialized] combination.
  /// Handles initial fetch when the  data is not yet present.
  ///
  /// On success it emits: [DataInitialFetching], [DataLoaded].
  /// On failure it emits: [DataInitialFetching], [DataInitialFetchingError], [DataUninitialized].
  Future<void> mapInitialFetchDataToStateSync(
    FetchDataSync<T> event,
    DataUninitialized state,
    Emitter<DataState<T>> emit,
    Either<F, T> Function<F>(DataState<T>, FetchDataSync<T>) fetchAndParseData,
  ) async {
    emit(DataInitialFetching());
    final res = fetchAndParseData(state as DataState<T>, event);

    res.fold((e) {
      emit(DataInitialFetchingError(e));
      emit(DataUninitialized());
    }, (data) {
      // skipped the fetching success state
      emit(DataLoaded(data));
    });
  }

  /// Handler for [FetchData] + [DataLoaded] combination.
  /// Handles refetch of the  data.
  ///
  /// On success it emits: [DataRefetching], [DataLoaded].
  /// On failure it emits: [DataRefetching], [DataRefetchingError], [DataLoaded].
  Future<void> mapRefetchDataToStateSync(
    FetchDataSync<T> event,
    DataLoaded<T> state,
    Emitter<DataState<T>> emit,
    Either<F, T> Function<F>(DataState<T>, FetchDataSync<T>) fetchAndParseData,
  ) async {
    emit(DataRefetching(state));
    final res = fetchAndParseData(state, event);
    final T data = res.getOrElse(() => state.data);

    res.fold((l) {
      emit(DataRefetchingError(l, state));
      emit(DataLoaded(data));
    }, (r) {
      emit(DataRefetchingSuccess(data));
      emit(DataLoaded(data));
    });
  }
}
