"""
Находит в системе `system` подсистему по заданному пути `path`
"""
# function _find_system(system::System, path)
#     popfirst!(path)
#     for name in path
#         system_ind = findfirst(b -> b.name == name, system.blocks)
#         system = system.blocks[system_ind]
#     end
#     return system
# end


"""
Проверяет модель `root` на наличие алгебраических петель
"""
function algebraic_loop_validator(root::Root)
    println(rool.graph_struct.graph)
    
end