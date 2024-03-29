# README
## Newer version at: https://github.com/benetis/weather-informer-events

## Disclaimer: Not for production use

## Disclaimer

I am making this project for the purpose of getting familiar with Ruby and RoR.
However, feel free to use it as you wish.

## Description

Simple weather forecast informer. Will send a notification if weather conditions are met.

- Call meteo.lt API to get weather data (Don't abuse their API, they have 20k daily limit. 24 requests per day should be
  more than enough)
    - Save data to database
- Run periodic worker which checks if data matches specified conditions
    - Ex: if it will rain today – send a notification
        - Email
        - Telegram bot
- Telegram API to ask about current conditions or forecast
    - `.` Will return a list of options to choose from.
        - `Kada lis?`, which returns nearest rain forecast
        - `Atnaujink duomenis`, which will update data
          ![bot_example.png](docs%2Fbot_example.png)
    - `orai` Will return warnings about today's weather

## Changelog

#### 1.1 version

Default timezone for TelegramBot is set to Vilnius. Telegram bot will respond in that timezone

## Overview

### Version 1

![overview.png](docs/overview_weather_informer_v1.png)

[Accompanying blog post for version 1](https://benetis.me/posts/ruby/weather-informer/)

## Running

- Locally
    - `docker-compose up -d` for Rails, Redis & Sidekiq
    - Database is SQLite, so no need to run anything

## Configuration

- `EDITOR="code --wait" rails credentials:edit`
- ```yml
  emails_to_notify: ["email@to_deliver.local"] #where to deliver notifications
  smtp: 
    user_name: "apikey"
    password: "SG...." #sendgrid api key
    from: "from@to_deliver.local" #sendgrid verified email
  telegram_api_key: "placeholder_key"
  telegram_chats_to_notify: ["chat_id"]
  telegram_allowed_chat_ids: ["chat_id"]
  ```