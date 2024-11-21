@testset "Processing" begin
    system_2 = System(
        name="System-2",
        number=1,
        atomic=true
    )
    system_1 = System(
        name="System-1",
        number=1,
        atomic=false
    )
    push!(system_1.blocks, system_2)
    root_system = System(
        name="Root System",
        number=1,
        atomic=false
    )
    push!(root_system.blocks, system_1)
    root = Root(
        name="Root",
        sample_rate=0.1,
        system=root_system
    )

    @test system_1.name == "System-1"
    @test system_1.number == 1
    @test system_1.atomic == false
    @test system_1.blocks == [system_2]

    @test root.name == "Root"
    @test root.sample_rate == 0.1
    @test root.system == root_system

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
    @test outward.feedthrough == true
    @test outward.inward == false
    @test outward.connected_with == [inward]
    @test inward.name == "Port-2"
    @test inward.number == 1
    @test inward.feedthrough == true
    @test inward.inward == true
    @test inward.connected_with == [outward]

    rm_connection!(root, outward="/System-1/Block-1/Port-1", inward="/System-1/Block-2/Port-2")
    
    @test isempty(root.system.blocks[1].blocks[2].ports)
    @test isempty(root.system.blocks[1].blocks[3].ports)

    rm_block!(root, "/System-1/Block-1")
    rm_block!(root, "/System-1/Block-2")

    add_block!(root, "/System-1/Source")
    add_block!(root, "/System-1/Variable Inputs")
    add_block!(root, "/System-1/State")
    add_block!(root, "/System-1/Sink")

    add_connection!(root, outward="/System-1/Source/Port-1", inward="/System-1/Variable Inputs/Port-1")
    add_connection!(root, outward="/System-1/State/Port-1", inward="/System-1/Variable Inputs/Port-2")
    add_connection!(root, outward="/System-1/Variable Inputs/Port-3", inward="/System-1/Sink/Port-1")

    @test algebraic_loop_validator(root) |> isnothing

    add_connection!(root, outward="/System-1/Variable Inputs/Port-3", inward="/System-1/State/Port-2")

    expected_msg = "Algebraic loops decected for blocks: [`/System-1/Variable Inputs`, `/System-1/State`]."
    @test_throws ValidationError(expected_msg) algebraic_loop_validator(root)
end