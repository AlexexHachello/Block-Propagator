"""
    Структура представления порта `Port`
    - `name`           -- имя порта
    - `number`         -- порядковый номер порта
    - `feedthrough`    -- может ли сигнал проходить насквозь
    - `inward`         -- для входных портов = true, для выходных = false 
    - `connected_with` -- вектор из портов, с которыми соединён порт
"""
struct Port
    name::String
    number::Int64
    feedthrough::Bool
    inward::Bool
    connected_with::Vector{Port}

    function Port(;
        name::String,
        number::Int64,
        feedthrough::Bool,
        inward::Bool,
        connected_with::Vector{Port}=Port[],        
    )
        new(
            name,
            number,
            feedthrough,
            inward,
            connected_with,
        )
    end
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
    number::Int64
    type::String
    ports::Vector{Port}

    function Block(;
        name::String,
        number::Int64,
        type::String,
        ports::Vector{Port}=Port[],
    )
        new(
            name,
            number,
            type,
            ports,
        )
    end
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
    number::Int64
    atomic::Bool
    blocks::Vector{Union{System, Block}}

    function System(;
        name::String,
        number::Int64,
        atomic::Bool,
        blocks::Vector{Union{System, Block}}=Union{System, Block}[],
    )
        new(
            name,
            number,
            atomic,
            blocks,
        )
    end
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

    function Root(;
        name::String,
        sample_rate::Number,
        system::System,
    )
        new(
            name,
            sample_rate,
            system
        )
    end
end