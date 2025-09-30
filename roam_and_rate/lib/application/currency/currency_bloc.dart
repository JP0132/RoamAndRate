import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/currency/currency_event.dart';
import 'package:roam_and_rate/application/currency/currency_state.dart';
import 'package:roam_and_rate/core/utils/helper/currency_rate.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyInitial()) {
    on<FetchConversionRate>((event, emit) async {
      emit(CurrencyLoading());
      try {
        final session = SessionManager();

        double? cachedRate = await session.getRate(
          event.base.toUpperCase(),
          event.target.toUpperCase(),
        );

        if (cachedRate == null) {
          final rate = await getExchangeRate(
            event.base.toUpperCase(),
            event.target.toUpperCase(),
          );

          if (rate != null) {
            await session.saveRate(rate.base, rate.target, rate.mid);

            final converted = convertAmount(
              event.value,
              rate.mid,
            ).toStringAsFixed(2);

            emit(CurrencyLoaded(converted));
          } else {
            emit(CurrencyError("Failed to fetch rate"));
          }
        } else {
          final converted = convertAmount(
            event.value,
            cachedRate,
          ).toStringAsFixed(2);
          emit(CurrencyLoaded(converted));
        }
      } catch (e) {
        emit(CurrencyError(e.toString()));
      }
    });
  }
}
