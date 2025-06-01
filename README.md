Telegram Test Bot
Bot link: t.me/SVVulossTest_bot
This is a Telegram bot built using the Cobra CLI library and the telebot package in Go. The bot responds to specific commands and is structured as a Cobra command-line application.
Features

Responds to /hello command with a greeting and the bot's version.
Responds to /day command with the current day of the week.
Handles unknown commands with a fallback response.
Uses Cobra for command-line interface management.
Configurable via environment variables.

Prerequisites

Go 1.16 or higher
A Telegram Bot Token (obtain from BotFather)
Required Go packages:
github.com/spf13/cobra
gopkg.in/telebot.v3

Installation

Clone the repository or copy the bot code to your project.
Install dependencies:go get github.com/spf13/cobra
go get gopkg.in/telebot.v3


Set the Telegram Bot Token as an environment variable:export TELE_TOKEN="your-bot-token-here"

Usage

Ensure the bot token is set in the environment variable TELE_TOKEN.
Build and run the bot using the Cobra command:go run main.go testBot

Alternatively, you can use the alias:go run main.go start


Interact with the bot on Telegram:
Send /hello to receive a greeting with the bot's version.
Send /day to get the current day of the week.
Send any other command to receive a fallback message.


License
This project is licensed under the MIT License.
Copyright © 2025 svvpro svvpro@gmail.com
