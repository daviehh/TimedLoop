module TimedLoop

using Dates
using Printf

export @tml, @tmlv


######## time to h:m:s
function hms(dt)
    (h, r) = divrem(dt, 60 * 60)
    (m, r) = divrem(r, 60)
    string(Int(h), ":", Int(m), ":", round(Int, r))
end



# https://github.com/JuliaLang/julia/blob/46ce4d79337bdd257ee2e3d2f4bb1c55ff0a5030/base/threadingconstructs.jl


function m_tml(iter, lbody, v_out)
    lidx = iter.args[1]         # index
    range = iter.args[2]

    return quote
        vout = $(esc(v_out))
        range_ = $(esc(range))
        n_loop = length(range_)
        local timing_total = 0.0
        println(">>>")
        for i in 1:n_loop
            timing_now = now()
            ## loop body
            local $(esc(lidx)) = range_[i]
            $(esc(lbody))
            ## end of loop body
            ##### timing logic
            timing_trj = (now() - timing_now).value / 1000
            timing_total += timing_trj
            timing_avg = timing_total / i

            should_print = vout || i < 10 || mod(i,10) == 0 || timing_avg > 5.0

            if should_print
                timing_tot_est = timing_avg * n_loop
                timing_rem = timing_tot_est - timing_total
                timing_eta = Dates.format(
                    now() + Dates.Millisecond(round(Int64, 1000 * timing_rem)),
                    "e, dd u yyyy HH:MM:SS",
                )
                @printf("%i/%i in %.3f sec.\n", i, n_loop, timing_trj)
                @printf("ETA: %s\ntotal run est. %s, %.3f s per loop, %s to go\n", timing_eta, hms(timing_tot_est), timing_avg, hms(timing_rem))
                println("="^7)
            end
        end #for
    end #quote
end


function construct_tml(args...)
    na = length(args)

    if !(na in (1,2))
        throw(ArgumentError("wrong number of arguments"))
    end

    if na == 1
        ex = args[1]
        v_out = false
    else
        ex = args[2]
        v_out = args[1]
        if !isa(v_out, Bool)
            throw(ArgumentError("verbose switch should be Boolean"))
        end
    end

    if !isa(ex, Expr)
        throw(ArgumentError("need an expression argument"))
    end

    if ex.head === :for
        iter = ex.args[1]
        lbody = ex.args[2]
        m_tml(iter, lbody, v_out)
    else
        throw(ArgumentError("unrecognized arguments"))
    end
end


macro tml(args...)
    construct_tml(args...)
end

macro tmlv(args...)
    construct_tml(true, args...)
end


end
#mod
