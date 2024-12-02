"""
    Структура представления частоты дискретезации `SampleTime`
    - `sample_time` -- частота дискретезации
    - `offset`      -- сдвиг
"""
struct SampleTime
    sample_time::Float64
    offset::Float64

    function SampleTime(;
        sample_time::Float64=-1.0,
        offset::Float64=-1.0,
    )
        offset > sample_time && throw(
            ValidationError("Offset can not be greater than sample time.")
        )

        new(
            sample_time,
            offset,
        )
    end
end


"""
    Структура представления типа данных сигнал `SignalDataType`
    - `data_type` -- тип данных
    - `complex`   -- есть ли мнимая часть
"""
struct SignalDataType
    data_type::DataType
    complex::Bool

    function SignalDataType(;
        data_type::DataType=Nothing,
        complex::Bool=false,
    )
        new(
            data_type,
            complex,
        )
    end
end


"""
    Структура представления атрибутов сигнала `SignalAttributes`
    - `sample_time` -- частота дискретезации
    - `propagated`  -- получены ли атрибуты сигнала
"""
struct SignalAttributes
    sample_time::SampleTime
    dimension::Tuple
    type::SignalDataType
    propagated::Bool

    function SignalAttributes(;
        sample_time::SampleTime=SampleTime(),
        dimension::Tuple=(),
        type::SignalDataType=SignalDataType(),
        propagated::Bool=false,
    )
        new(
            sample_time,
            dimension,
            type,
            propagated,
        )
    end
end


"""
    Структура представления порта `Port`
    - `name`              -- имя порта
    - `number`            -- порядковый номер порта
    - `feedthrough`       -- может ли сигнал проходить насквозь
    - `inward`            -- для входных портов = true, для выходных = false 
    - `connected_with`    -- вектор из портов, с которыми соединён порт
    - `signal_attributes` -- атрибуты сигнала
"""
struct Port
    name::String
    number::Int64
    feedthrough::Bool
    inward::Bool
    connected_with::Vector{Port}
    signal_attributes::SignalAttributes

    function Port(;
        name::String,
        number::Int64,
        feedthrough::Bool,
        inward::Bool,
        connected_with::Vector{Port}=Port[],
        signal_attributes::SignalAttributes=SignalAttributes(),
    )
        new(
            name,
            number,
            feedthrough,
            inward,
            connected_with,
            signal_attributes,
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