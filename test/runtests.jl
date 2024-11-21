using BlockPropagator, Test

using BlockPropagator.Errors

@testset verbose = true "BlockPropagator" begin
    include("test_processing.jl")
end