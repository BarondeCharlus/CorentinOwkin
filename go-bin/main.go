package main

import (
    "fmt"
    "os"
    "bytes"
    "io/ioutil"
	"net/http"
    "strconv"
)

func getEUID() int {
    if os.Geteuid() == 0 {
       return 1
    }

    return 0
}

func sumPerf(x int, y string) int {
    sv, _ := strconv.Atoi(y)
    return sv + x
}

func setStatus(x int) string {
     if x < 1 {
        return "success"
     }
     return "fail"
}



func main() {
    performance := getEUID()
    perf := os.Getenv("PERFORMANCE")
    performance = sumPerf(performance, perf)

    f, err := os.Create("/data/perf.json")
    if err != nil {
       fmt.Println(err)
       return
    }

    _, err = f.WriteString(fmt.Sprintf("%d",performance))
    if err != nil {
       fmt.Println(err)
       f.Close()
       return
    }

    err = f.Close()
    if err != nil {
       fmt.Println(err)
       return
    }

    uuid := os.Getenv("UUID")
    name := os.Getenv("NAME")
    description := os.Getenv("DESCRIPTION")
    dockerfile := os.Getenv("DOCKERFILE")
    status := setStatus(performance)

    var jsonData = []byte(fmt.Sprintf(`{
	    	"id": %v,
		    "name": %v,
		    "description": %v,
		    "dockerfile": %v,
            "status": %v,
            "performance": %v
	 }`, uuid, name, description, dockerfile, status, performance))

    fmt.Println(bytes.NewBuffer(jsonData))
	url := "http://192.168.49.2/api/v1/job/" + uuid

    request, error := http.NewRequest("PUT", url, bytes.NewBuffer(jsonData))
	request.Header.Set("Content-Type", "application/json; charset=UTF-8")

	client := &http.Client{}
	response, error := client.Do(request)
	if error != nil {
		panic(error)
	}
	defer response.Body.Close()

	body, _ := ioutil.ReadAll(response.Body)
	fmt.Println("response Body:", string(body))

}
