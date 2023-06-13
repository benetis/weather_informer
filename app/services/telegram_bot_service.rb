# frozen_string_literal: true

class TelegramBotService

  def initialize
    @monitoring = ConditionalMonitoringService.new
    @telegram_printer = TelegramPrinter.new
  end

  def button_callback(bot, message)
    if message.data == 'when_will_it_rain'
      next_trigger = @monitoring.check_forecasts(Time.now.., [:rain])
                                .sort_by { |trigger| trigger[:rain] }
                                .first

      reply = @telegram_printer.next_rains(next_trigger)

      bot.api.send_message(chat_id: message.from.id, text: reply)
    end
    if message.data == 'refresh_data'
      bot.api.send_message(chat_id: message.from.id, text: 'Atnaujinu duomenis...')
      ForecastDownloadWorker.perform_sync
      bot.api.send_message(chat_id: message.from.id, text: 'Duomenys atnaujinti')
    end
  end

  def dot_selected(bot, message)
    kb = [[
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Kada lis?', callback_data: 'when_will_it_rain'),
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Atnaujink duomenis', callback_data: 'refresh_data')
          ]]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: message.chat.id, text: 'Pasirink', reply_markup: markup)
  end

  def weather_today_selected(bot, message)
    triggers = @monitoring.check_forecasts(Time.now..Date.today.end_of_day, [:rain, :hot, :scorching, :windy])

    reply = @telegram_printer.print_triggers(triggers)

    bot.api.send_message(chat_id: message.chat.id, text: reply)
  end

  def kaunas_selected(bot, message)
    bot.api.send_message(chat_id: message.chat.id, text: "<Placeholder command>, #{message.chat.id}")
  end
end
