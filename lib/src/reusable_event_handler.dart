

import 'package:bloc/bloc.dart';
import 'package:reusable_bloc/src/reusable_event.dart';
import 'package:reusable_bloc/src/reusable_state.dart';

class DataEventHandler<Data> {
  const DataEventHandler();

  /// Handler for [FetchData] + [DataUninitialized] combination.
  /// Handles initial fetch when the  data is not yet present.
  ///
  /// On success it emits: [DataInitialFetching], [DataLoaded].
  /// On failure it emits: [DataInitialFetching], [DataInitialFetchingError], [DataUninitialized].
  Future<void> mapInitialFetchDataToState(
    FetchData event,
    DataUninitialized state,
    Emitter<DataState<Data>> emit,
    Function(DataState<Data>, FetchData) fetchAndParseData,
  ) async {
    try {
      emit(DataInitialFetching());
      final Data data = await fetchAndParseData(state as DataState<Data>, event);
      emit(DataLoaded(data));
    } catch (e) {
      print(e);
      emit(DataInitialFetchingError(e));
      emit(DataUninitialized());
    }
  }

  /// Handler for [FetchData] + [DataLoaded] combination.
  /// Handles refetch of the  data.
  ///
  /// On success it emits: [DataRefetching], [DataLoaded].
  /// On failure it emits: [DataRefetching], [DataRefetchingFailed], [DataLoaded].
  Future<void> mapReFetchDataToState(
    FetchData<Data> event,
    DataLoaded<Data> state,
    Emitter<DataState<Data>> emit,
    Function(DataState<Data>, FetchData<Data>) fetchAndParseData,
  ) async {
    try {
      emit(DataRefetching(state));
      final Data data = await fetchAndParseData(state, event);
      emit(DataRefetchingSuccess(data));
      emit(DataLoaded(data));
    } catch (e) {
      print(e);
      emit(DataRefetchingError(state, e));
      emit(DataLoaded.clone(state));
    }
  }
}