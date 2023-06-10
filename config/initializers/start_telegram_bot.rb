
if Rails.env.production?
  TelegramBotWorker.perform_async
end
