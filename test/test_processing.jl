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

    add_block!(root, "/System-1/Block-1")
    add_block!(root, "/System-1/Block-2")
    add_connection!(root, outward="/System-1/Block-1/Port-1", inward="/System-1/Block-2/Port-2")
    outward = root.system.blocks[1].blocks[2].ports[1]
    inward = root.system.blocks[1].blocks[3].ports[1]

    @test outward.name == "Port-1"
    @test outward.number == 1
    @test outward.feedthrough == false
    @test outward.inward == false
    @test outward.connected_with == [inward]
    @test inward.name == "Port-2"
    @test inward.number == 1
    @test inward.feedthrough == false
    @test inward.inward == true
    @test inward.connected_with == [outward]

    rm_connection!(root, outward="/System-1/Block-1/Port-1", inward="/System-1/Block-2/Port-2")
    @test isempty(root.system.blocks[1].blocks[2].ports)
    @test isempty(root.system.blocks[1].blocks[3].ports)
end