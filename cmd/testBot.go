/*
Copyright © 2025 NAME HERE svvpro@gmai.com
*/
package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	TeleToken = os.Getenv("TELE_TOKEN")
)

// testBotCmd represents the testBot command
var testBotCmd = &cobra.Command{
	Use:     "testBot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("testBot %s started", appVersion)

		kbot, err := telebot.NewBot(telebot.Settings{
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
		if err != nil {
			log.Fatalf("Please check TELE_TOKEN evn var: %s", err)
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Print(m.Message().Payload, m.Text())
			payload := m.Message().Payload
			switch payload {
			case "hello":
				err = m.Send(fmt.Sprintf("Hello I am Test bot ver: %s !", appVersion))
			case "day":
				currentDay := time.Now().Weekday().String()
				err = m.Send(fmt.Sprintf("Today is %s", currentDay))
			default:
				err = m.Send("I don't understand this command. Try /hello or /day")
			}
			return err
		})

		// Запуск бота
		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(testBotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// testBotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// testBotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
