package global

import (
	"github.com/spf13/viper"
	"jobs_crawler/util"
	"os"
	"path/filepath"
	"sync"
	"time"
)

func init() {
	App.Name = os.Args[0]
	App.Version = "V1.0"
	App.LaunchTime = time.Now()

	App.RootDir = "."

	if !viper.InConfig("http.port") {
		App.RootDir = inferRootDir()
	}

	fileInfo, err := os.Stat(os.Args[0])
	if err != nil {
		panic(err)
	}

	App.Date = fileInfo.ModTime()
}

func inferRootDir() string {
	cwd, err := os.Getwd()
	if err != nil {
		panic(err)
	}
	var infer func(d string) string
	infer = func(d string) string {
		if util.Exist(d + "/config") {
			return d
		}

		return infer(filepath.Dir(d))
	}

	return infer(cwd)
}

var App = &app{}

type app struct {
	Name    string
	Version string
	Date    time.Time

	// 项目根目录
	RootDir string

	// 启动时间
	LaunchTime time.Time
	UpTime     time.Duration

	locker sync.Mutex
}

func (a *app) SetUpTime() {
	a.locker.Lock()
	defer a.locker.Unlock()
	a.UpTime = time.Now().Sub(a.LaunchTime)
}
