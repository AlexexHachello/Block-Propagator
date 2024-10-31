module BlockPropagator

export
    Port,
    Block,
    System, 
    Root

export
    add_block!,
    rm_block!,
    add_connection!

include("main_structures.jl")
include("processing.jl")

end # module BlockPropagator