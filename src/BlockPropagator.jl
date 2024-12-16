module BlockPropagator

using Graphs

export
    SampleTime,
    SignalDataType,
    SignalAttributes,
    Port,
    Block,
    System,
    Root

export
    add_block!,
    rm_block!,
    add_connection!,
    rm_connection!,
    algebraic_loop_validator,
    propagate_signal_attributes_block!

include("main_structures.jl")
include("model_creator.jl")
include("algebraic_loop_validator.jl")
include("signal_attributes_propagator.jl")
include("errors.jl")
using .Errors

end # module BlockPropagator