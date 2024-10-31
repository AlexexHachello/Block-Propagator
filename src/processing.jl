function find_system(root, path_to_block)
    popfirst!(path_to_block)
    system = root.system
    for name in path_to_block
        system_ind = findfirst(b -> b.name == name, system.blocks)
        system = system.blocks[system_ind]
    end
    return system
end

function add_block!(root, block_full_name)
    path_to_block = split(block_full_name, "/")
    block_name = pop!(path_to_block)
    system = find_system(root, path_to_block)
    push!(system.blocks, 
        Block(
            block_name,
            length(system.blocks) + 1,
            "BlockType",
            Port[],
        )
    )
end

function rm_block!(root, block_full_name)
    path_to_block = split(block_full_name, "/")
    block_name = pop!(path_to_block)
    system = find_system(root, path_to_block)
    block_ind = findfirst(b -> b.name == block_name, system.blocks)
    deleteat!(system.blocks, block_ind)
end