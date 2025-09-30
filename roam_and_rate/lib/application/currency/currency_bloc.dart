import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/currency/currency_event.dart';
import 'package:roam_and_rate/application/currency/currency_state.dart';
import 'package:roam_and_rate/core/utils/helper/currency_rate.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyInitial()) {
    on<FetchConversionRate>((event, emit) async {
      emit(CurrencyLoading());
      try {
        final rate = await getExchangeRate(
          event.base.toUpperCase(),
          event.target.toUpperCase(),
        );

        if (rate != null) {
          final converted = convertAmount(event.value, rate).toStringAsFixed(2);
          emit(CurrencyLoaded(converted));
        } else {
          emit(CurrencyError("Failed to fetch rate"));
        }
      } catch (e) {
        emit(CurrencyError(e.toString()));
      }
    });
  }
}
