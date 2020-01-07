using Mux
using JSON

cd(dirname(@__FILE__))

main = read("test_json.html", String)

v = Vector{Tuple{Int, Int}}()
for i in 0:49, j in 0:49
    if rand() < 0.05 push!(v, (i, j)) end
end

function next(v)
    res = Vector{Tuple{Int, Int}}()
    for i in 0:49, j in 0:49
        if rand() < 0.05 push!(res, (i, j)) end
    end
    res
end

function next(v)
    for (i, el) in enumerate(v)
        v[i]  = (mod(el[1] + 1, 50), mod(el[2] + 1, 50))
    end
    v
end

next(v)

@app d3 = (
    Mux.defaults,
    # page(req -> Dict(:body => "Hello")),
    page("/", req -> Dict(
        :body => read("test_json.html", String))),
    page("/data", req -> Dict(
            :headers => ["Content-Type" => "application/json"],
            :body => JSON.json(next(v))
        )),
    Mux.notfound()
)

t1 = serve(d3)

Mux.App

respond("Hello")(r)
(req -> Dict(:body => "Hello"))(r)

h = Mux.App(mux(
    Mux.defaults,
    page(respond(main)),
    page("/data", respond(Dict(
        :headers => ["Content-Type" => "application/json"],
        # :body => JSON.json(JSON.parse(read("./data/users.json", String))))
        :body => JSON.json(next(v)))
    )),
    page("/rand", req -> string(rand())),
    Mux.notfound()
))

serve(h, 7999)

@app h0 = (
    Mux.defaults,
    page(respond(string(rand())))
)

h0.warez()

m0 = mux(page(respond(string(rand()))))
m0(r)

r1 = page(respond("xxx"))
r2 = respond(string(rand()))
r2(r)[:body]

r2 = respond()

Mux.response(string(rand()))

r = HTTP.Messages.Request("GET", "/rand")
h0.warez(r)
using HTTP

HTTP.serve("127.0.0.1", 7998) do request::HTTP.Request
   @show request
   @show request.method
   @show request.target
   @show HTTP.header(request, "Content-Type")
   @show HTTP.payload(request)
   try
       return HTTP.Response(string(rand()))
   catch e
       return HTTP.Response(404, "Error: $e")
   end
end

l() = x -> rand()

l()(1)

respond(string(rand()))
