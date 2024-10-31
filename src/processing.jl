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
    block_name = pop!(path_to_block)
    system = _find_system(root.system, path_to_block)

    push!(system.blocks,
        Block(
            block_name,
            length(system.blocks) + 1,
            "BlockType",
            Port[],
        )
    )
end


"""
Удаляет из модели `root` блок по полному имени `block`
"""
function rm_block!(root::Root, block::String)
    path_to_block = split(block, "/")
    block_name = pop!(path_to_block)
    system = _find_system(root.system, path_to_block)

    block_ind = findfirst(b -> b.name == block_name, system.blocks)

    deleteat!(system.blocks, block_ind)
end


"""
Находит в системе `system` блоки по путям `path_to_outward` и `path_to_inward`
"""
function _find_out_in_blocks(system::System, path_to_outward, path_to_inward)
    outward_block_name = pop!(path_to_outward)
    inward_block_name = pop!(path_to_inward)
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
    outward_port_name = pop!(path_to_outward)
    path_to_inward = split(inward, "/")
    inward_port_name = pop!(path_to_inward)

    outward_block, inward_block = _find_out_in_blocks(
        root.system, path_to_outward, path_to_inward)

    outward_port = Port(
        outward_port_name,
        length(outward_block.ports) + 1,
        true,
        false,
        Port[],
    )

    inward_port = Port(
        inward_port_name,
        length(inward_block.ports) + 1,
        true,
        true,
        [outward_port],
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
    outward_port_name = pop!(path_to_outward)
    path_to_inward = split(inward, "/")
    inward_port_name = pop!(path_to_inward)

    outward_block, inward_block = _find_out_in_blocks(
        root.system, path_to_outward, path_to_inward)
    outward_port_ind = findfirst(p -> p.name == outward_port_name, outward_block.ports)
    inward_port_ind = findfirst(p -> p.name == inward_port_name, inward_block.ports)

    deleteat!(outward_block.ports, outward_port_ind)
    deleteat!(inward_block.ports, inward_port_ind)
end