module BlockPropagator

using Graphs

export
    Port,
    Block,
    System,
    Root

export
    add_block!,
    rm_block!,
    add_connection!,
    rm_connection!,
    algebraic_loop_validator

include("main_structures.jl")
include("model_creator.jl")
include("algebraic_loop_validator.jl")
include("errors.jl")
using .Errors

end # module BlockPropagator