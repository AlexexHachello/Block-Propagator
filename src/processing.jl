"""
Находит в системе `system` подсистему по заданному пути `path`
"""
function _find_system(system::System, path)
    popfirst!(path)
    for name in path
        system_ind = findfirst(b -> b.name == name, system.blocks)
        system = system.blocks[system_ind]
    end
    return system
end


"""
Добавляет в модель `root` блок по полному имени `block`
"""
function add_block!(root::Root, block::String)
    path_to_block = split(block, "/")
    block_name = pop!(path_to_block) |> string
    system = _find_system(root.system, path_to_block)

    push!(system.blocks,
        Block(
            name=block_name,
            number=length(system.blocks) + 1,
            type="BlockType",
        )
    )
end


"""
Удаляет из модели `root` блок по полному имени `block`
"""
function rm_block!(root::Root, block::String)
    path_to_block = split(block, "/")
    block_name = pop!(path_to_block) |> string
    system = _find_system(root.system, path_to_block)

    block_ind = findfirst(b -> b.name == block_name, system.blocks)

    deleteat!(system.blocks, block_ind)
end


"""
Находит в системе `system` блоки по путям `path_to_outward` и `path_to_inward`
"""
function _find_out_in_blocks(system::System, path_to_outward, path_to_inward)
    outward_block_name = pop!(path_to_outward) |> string
    inward_block_name = pop!(path_to_inward) |> string
    system = _find_system(system, path_to_outward)

    outward_ind = findfirst(b -> b.name == outward_block_name, system.blocks)
    inward_ind = findfirst(b -> b.name == inward_block_name, system.blocks)

    return system.blocks[outward_ind], system.blocks[inward_ind]
end


"""
Добавляет в модель `root` соединение блоков `outward` и `inward`
"""
function add_connection!(root::Root; outward::String, inward::String)
    path_to_outward = split(outward, "/")
    outward_port_name = pop!(path_to_outward) |> string
    path_to_inward = split(inward, "/")
    inward_port_name = pop!(path_to_inward) |> string

    outward_block, inward_block = _find_out_in_blocks(
        root.system, path_to_outward, path_to_inward)

    outward_port = Port(
        name=outward_port_name,
        number=length(outward_block.ports) + 1,
        feedthrough=true,
        inward=false,
    )

    inward_port = Port(
        name=inward_port_name,
        number=length(inward_block.ports) + 1,
        feedthrough=true,
        inward=true,
        connected_with=[outward_port],
    )
    
    push!(outward_port.connected_with, inward_port)
    push!(outward_block.ports, outward_port)
    push!(inward_block.ports, inward_port)
end


"""
Удаляет из модели `root` соединение блоков `outward` и `inward`
"""
function rm_connection!(root::Root; outward::String, inward::String)
    path_to_outward = split(outward, "/")
    outward_port_name = pop!(path_to_outward) |> string
    path_to_inward = split(inward, "/")
    inward_port_name = pop!(path_to_inward) |> string

    outward_block, inward_block = _find_out_in_blocks(
        root.system, path_to_outward, path_to_inward)
    outward_port_ind = findfirst(p -> p.name == outward_port_name, outward_block.ports)
    inward_port_ind = findfirst(p -> p.name == inward_port_name, inward_block.ports)

    deleteat!(outward_block.ports, outward_port_ind)
    deleteat!(inward_block.ports, inward_port_ind)
end