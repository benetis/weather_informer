# README

## Project: Work in progress

## Disclaimer
I am making this project for the purpose of getting familiar with Ruby and RoR. 
However, feel free to use it as you wish.

## Running
- Locally
  - `docker-compose up -d` for Redis
  - Database is SQLite, so no need to run anything
  - `rails server`
  - `bundle exec sidekiq` for notifications

## Configuration
- `EDITOR="code --wait" rails credentials:edit`
- ```yml
  emails_to_notify: ["email@to_deliver.local"] #where to deliver notifications
  smtp: 
    user_name: "apikey"
    password: "SG...." #sendgrid api key
    from: "from@to_deliver.local" #sendgrid verified email
  ```