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
    Структура представления соединений модели `Connections`
    - `graph`       -- граф компонентов системы
    - `block_names` -- упорядоченных вектор имён блоков
"""
struct Connections
    graph::DiGraph
    block_names::Vector{String}

    function Connections(;
        graph::DiGraph=DiGraph(),
        block_names::Vector{String}=String[],
    )
        new(
            graph,
            block_names,
        )
    end
end

"""
    Структура представления модели `Root`
    - `name`        -- имя модели
    - `sample_rate` -- частота дискретезации
    - `system`      -- корневая система
    - `connections` -- информация о соединениях в модели
"""
struct Root
    name::String
    sample_rate::Number
    system::System
    connections::Connections

    function Root(;
        name::String,
        sample_rate::Number,
        system::System,
        connections::Connections=Connections(),
    )
        new(
            name,
            sample_rate,
            system,
            connections
        )
    end
end