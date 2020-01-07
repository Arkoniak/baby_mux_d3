using Mux
import Mux.WebSockets

cd(dirname(@__FILE__))

main = read("socket.html", String)

@app d3 = (
    Mux.defaults,
    page(respond(main)),
    page("/data/users.json", respond(read("./data/users.json", String))),
    Mux.notfound()
)

# wait(serve(d3))
# @sync serve(d3)
# t1 = serve(d3)

function ws_io(x)
    conn = x[:socket]

    while !eof(conn)
        data = WebSockets.readguarded(conn)
        data_str = String(data[1])
        println("Received data: " * data_str)

        WebSockets.writeguarded(conn, "Hey, I've received " * data_str)
    end
end

@app w = (
    Mux.wdefaults,
    route("/ws_io", ws_io),
    Mux.wclose,
    Mux.notfound());

t1 = @async WebSockets.serve(
    WebSockets.ServerWS(
        Mux.http_handler(d3),
        Mux.ws_handler(w),
    ), 8000);
