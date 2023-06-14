require 'telegram_bot_worker'

if Rails.env.production?
  TelegramBotWorker.perform_async
end
