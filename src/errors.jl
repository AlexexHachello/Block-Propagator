module Errors

export ValidationError

struct ValidationError <: Exception
    message::String
end

end # module Errors