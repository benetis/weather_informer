# frozen_string_literal: true

class TelegramBotService
  def touch_callback(bot, message)
    if message.data == 'touch'
      bot.api.send_message(chat_id: message.from.id, text: "<Placeholder>")
    end
  end

  def dot_selected(bot, message)
    kb = [[
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Kada lis?', callback_data: 'touch'),
          ]]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: message.chat.id, text: 'Pasirink', reply_markup: markup)
  end

  def weather_today_selected(bot, message)
    bot.api.send_message(chat_id: message.chat.id, text: "Nėra lietaus")
  end

  def kaunas_selected(bot, message)
    bot.api.send_message(chat_id: message.chat.id, text: "<Placeholder command>, #{message.chat.id}")
  end
end
