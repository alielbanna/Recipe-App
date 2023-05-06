import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_app/models/Faliure.dart';
import 'package:recipe_app/models/search_results.dart';
import 'package:recipe_app/repo/get_search_results.dart';

part 'search_results_event.dart';
part 'search_results_state.dart';

class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  final repo = SearchRepo();
  SearchResultsBloc() : super(SearchResultsInitial()) {
    on<SearchResultsEvent>((event, emit) async {
      if (event is LoadSearchResults) {
        try {
          emit(SearchResultsLoading());
          final results = await repo.getSearchList(event.name, 100);
          emit(SearchResultsSuccess(
            results: results.list,
          ));
        } on Failure catch (e) {
          emit(HomeFailureState(error: e));
        } catch (e) {
          print(e.toString());
          emit(SearchResultsError());
        }
      }
    });
  }
}
