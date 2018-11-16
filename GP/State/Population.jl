############################################
# Represent the population of a generation.
#
include("./Individual.jl")

struct Population
    members::Array{Individual}
    fitness::Array{Int}

    Population() = new(Individual[], Int[])
end
