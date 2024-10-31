"""
Находит в модели `root` подсистему по заданному пути `path_to_block`
"""
function _find_system(root::Root, path_to_block)
    popfirst!(path_to_block)
    system = root.system
    for name in path_to_block
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
    system = _find_system(root, path_to_block)
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
    system = _find_system(root, path_to_block)
    block_ind = findfirst(b -> b.name == block_name, system.blocks)
    deleteat!(system.blocks, block_ind)
end


"""
Добавляет в модель `root` соединение блоков `outward` и `inward`
"""
function add_connection!(root::Root; outward::String, inward::String)
    path_to_outward = split(outward, "/")
    outward_name = pop!(path_to_outward)
    path_to_inward = split(inward, "/")
    inward_name = pop!(path_to_inward)
    system = _find_system(root, path_to_outward)
    outward_ind = findfirst(b -> b.name == outward_name, system.blocks)
    inward_ind = findfirst(b -> b.name == inward_name, system.blocks)
    outward_block = system.blocks[outward_ind]
    inward_block = system.blocks[inward_ind]
    outward_port = Port(
        "Port-1-1",
        length(outward_block.ports) + 1,
        false,
        false,
        Port[],
    )
    inward_port = Port(
        "Port-2-1",
        length(inward_block.ports) + 1,
        false,
        true,
        [outward_port],
    )
    push!(outward_port.connected_with, inward_port)
    push!(outward_block.ports, outward_port)
    push!(inward_block.ports, inward_port)
end