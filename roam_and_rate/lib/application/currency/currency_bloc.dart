import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/currency/currency_event.dart';
import 'package:roam_and_rate/application/currency/currency_state.dart';
import 'package:roam_and_rate/core/utils/helper/currency_rate.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyLoaded({})) {
    // Start with empty map
    on<FetchConversionRate>((event, emit) async {
      final currentState = state;
      if (currentState is CurrencyLoaded) {
        // Create a copy of current conversions
        final newConversions = Map<String, String>.from(
          currentState.conversions,
        );

        emit(CurrencyLoading()); // You might need to adjust this

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
              newConversions[event.expenseId] = converted;
              emit(CurrencyLoaded(newConversions));
            } else {
              // Keep previous conversions, just mark this one as error?
              emit(CurrencyLoaded(newConversions));
            }
          } else {
            final converted = convertAmount(
              event.value,
              cachedRate,
            ).toStringAsFixed(2);
            newConversions[event.expenseId] = converted;
            emit(CurrencyLoaded(newConversions));
          }
        } catch (e) {
          // Keep previous conversions on error
          emit(CurrencyLoaded(newConversions));
        }
      }
    });
  }
}
