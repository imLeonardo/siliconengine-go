package main

import (
	"fmt"
	"silicon-go/config"
	"silicon-go/database"
	"silicon-go/flag"
	"silicon-go/http"
	"silicon-go/logger"
	"silicon-go/worker"
	"runtime/debug"
	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"
)

func main() {
	defer func() {
		if r := recover(); r != nil {
			debug.PrintStack()
			fmt.Printf("panic from main, r %v, stack %s", r, string(debug.Stack()))
		}
	}()

	appFlag, err := flag.NewFlag()
	if err != nil {
		panic(err)
	}

	appConfig, err := config.NewConfig(appFlag)
	if err != nil {
		panic(err)
	}

	fxOptions := app.GetAppModule(appConfig)

	fx.New(
		//flag.FxModule,
		//config.FxModule,
		fx.Supply(appConfig),
		logger.FxModule,
		worker.FxModule,
		cluster.FxModule,
		http.FxModule,
		database.FxModule,
		handler.FxModule,
		app.FxModule,
		fx.Options(fxOptions...),
		fx.WithLogger(func(logger *logger.Logger) fxevent.Logger {
			return &fxevent.ZapLogger{Logger: logger.ZapLogger}
		}),
		fx.Invoke(func(app *app.App) {

		}),
	).Run()
}
