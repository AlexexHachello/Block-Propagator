using BlockPropagator, Test

@testset verbose = true "BlockPropagator" begin
    include("test_processing.jl")
end