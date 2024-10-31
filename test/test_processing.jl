@testset "Processing" begin
    system_2 = System(
        "System-2", 
        1, 
        true,
        Block[]
    )
    system_1 = System(
        "System-1", 
        1, 
        true,
        [system_2]
    )
    root_system = System(
        "Root System", 
        1, 
        true,
        [system_1]
    )
    root = Root(
        "Root", 
        0.1,
        root_system
    )

    add_block!(root, "/System-1/System-2/Block-1")

    block_1 = root.system.blocks[1].blocks[1].blocks[1] 
    @test block_1.name == "Block-1"
    @test block_1.number == 1
    @test block_1.type == "BlockType"
    @test block_1.ports == Port[]

    rm_block!(root, "/System-1/System-2/Block-1")
    @test isempty(root.system.blocks[1].blocks[1].blocks)
end