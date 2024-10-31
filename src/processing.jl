"""
Находит в модели `root` подсистему по заданному пути `path_to_block`
"""
function _find_system(root, path_to_block)
    popfirst!(path_to_block)
    system = root.system
    for name in path_to_block
        system_ind = findfirst(b -> b.name == name, system.blocks)
        system = system.blocks[system_ind]
    end
    return system
end


"""
Добавляет в модель `root` блок по полному имени `block_full_name`
"""
function add_block!(root, block_full_name)
    path_to_block = split(block_full_name, "/")
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
Удаляет из модели `root` блок по полному имени `block_full_name`
"""
function rm_block!(root, block_full_name)
    path_to_block = split(block_full_name, "/")
    block_name = pop!(path_to_block)
    system = _find_system(root, path_to_block)
    block_ind = findfirst(b -> b.name == block_name, system.blocks)
    deleteat!(system.blocks, block_ind)
end