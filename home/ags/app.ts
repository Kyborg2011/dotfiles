import { app } from "gi://Astal?version=3.0"
import style from "./style.scss"
import Bar from "./widget/Bar"

app.start({
    css: style,
    instanceName: "js",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => app.get_monitors().map(Bar),
})
