"""
Распространяет атрибуты сигнала для блока `block` от входных портов 
к выходным, если `forward` = true и наоборот, если `forward` = false.
"""
function propagate_signal_attributes_block!(block; forward=true)
    ports_sa = Set{SignalAttributes}()
    for port in block.ports
        port.inward == forward && push!(ports_sa, port.signal_attributes)
    end

    port_type = forward ? "Inports" : "Outports"
    length(ports_sa) > 1 && throw(ValidationError("Different sample time for $port_type in `$(block.name)`"))
    
    propagated_sa = collect(ports_sa)[1]
    propagated_sa == SignalAttributes() && return

    for port in block.ports
        (port.inward == forward || port.signal_attributes.propagated) && continue
        port.signal_attributes = propagated_sa

        for conn_port in port.connected_with
            conn_port.signal_attributes.propagated && continue
            conn_port.signal_attributes = propagated_sa
        end
    end
end