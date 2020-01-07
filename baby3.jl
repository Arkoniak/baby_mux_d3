using GridViewer
import GridViewer.update

mutable struct Maze <: AbstractGrid
    v::Vector{Tuple{Int, Int}}
end

m = Maze([(10, 10), (20, 20)])

function GridViewer.update(m::Maze)
    for (i, elem) in enumerate(m.v)
        m.v[i] = (mod(elem[1] + 1, 100), mod(elem[2] + 2, 100))
    end
    m.v
end

grid = D3Grid(100, 100, m)

t = GridViewer.run(grid)

@async Base.throwto(t, InterruptException())

update(grid.f)

println(@which update(grid.f))

typeof(grid.f)
