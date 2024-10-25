"""
    Структура представления порта `Port`
    - `name`           -- имя порта
    - `number`         -- порядковый номер порта
    - `feedthrough`    -- может ли проходить петля
    - `inward`         -- для входных портов = true, для выходных = false 
    - `connected_with` -- вектор из портов, с которыми соединён порт
"""
struct Port
    name::String
    number::UInt64
    feedthrough::Bool
    inward::Bool
    connected_with::Vector{Port}
end


"""
    Структура представления блока `Block`
    - `name`   -- имя блока
    - `number` -- порядковый номер блока
    - `type`   -- тип блока
    - `ports`  -- вектор из портов блока
"""
struct Block
    name::String
    number::UInt64
    type::String
    ports::Vector{Port}
end


"""
    Структура представления системы `System`
    - `name`   -- имя системы
    - `number` -- порядковый номер системы
    - `atomic` -- является ли система атомарной
    - `blocks` -- вектор из систем или блоков, содержащихся в системе
"""
struct System
    name::String
    number::UInt64
    atomic::Bool
    blocks::Vector{Union{System, Block}}
end


"""
    Структура представления модели `Root`
    - `name`        -- имя модели
    - `sample_rate` -- частота дискретезации
    - `system`      -- корневая система
"""
struct Root
    name::String
    sample_rate::Number
    system::System
end