"""
Проверяет модель `root` на наличие алгебраических петель
"""
function algebraic_loop_validator(root::Root)
    block_names = root.connections.block_names
    strong_components = strongly_connected_components_tarjan(root.connections.graph)
   
    length(strong_components) == length(block_names) && return

    message = "Algebraic loops decected for blocks: "
    for comps in strong_components
        length(comps) == 1 && continue
        message *= string([block_names[c] for c in comps]) * ", "
    end
    message = replace(chop(message, head=0, tail=2), "\"" => "`") * "."

    throw(ValidationError(message))
end