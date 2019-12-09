package global

import (
	"flag"
	"fmt"
	"log"
	"math/rand"
	"sync"
	"time"

	"github.com/fsnotify/fsnotify"
	"github.com/spf13/viper"
)

var once = new(sync.Once)

var (
	NeedAll   = flag.Bool("all", false, "是否需要全量抓取，默认否")
	WhichSite = flag.String("site", "", "抓取哪个站点(空表示所有站点)")
	config    = flag.String("config", "config", "环境变量档案名称, 默认config")
)

func Init() {
	once.Do(func() {
		if !flag.Parsed() {
			flag.Parse()
		}

		rand.Seed(time.Now().UnixNano())

		viper.SetConfigName(*config)
		viper.AddConfigPath("/etc/crawler/")
		viper.AddConfigPath("$HOME/.crawler/")
		viper.AddConfigPath(App.RootDir + "config/")
		err := viper.ReadInConfig()
		if err != nil {
			panic(fmt.Errorf("Fatal error config files: %s \n", err))
		}
		watchConfig()
	})
}

// 监听配置文件变化
func watchConfig() {
	viper.WatchConfig()
	viper.OnConfigChange(func(e fsnotify.Event) {
		log.Printf("config file changed: %s \n", e.Name)
	})
}
