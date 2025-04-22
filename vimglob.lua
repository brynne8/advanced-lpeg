local lpeg = require("lpeg")
local P, S, V, R, B = lpeg.P, lpeg.S, lpeg.V, lpeg.R, lpeg.B
local C, Cc, Ct, Cf, Cmt = lpeg.C, lpeg.Cc, lpeg.Ct, lpeg.Cf, lpeg.Cmt

local M = {}
local pathsep = P('/')

-- Helper function to replace vim.tbl_map
local function tbl_map(func, tbl)
    local newtbl = {}
    for i, v in ipairs(tbl) do
        newtbl[i] = func(v)
    end
    return newtbl
end

-- Helper function to replace vim.iter
local function iter(tbl)
    return {
        fold = function(_, init, func)
            for _, v in ipairs(tbl) do
                init = func(init, v)
            end
            return init
        end
    }
end

--- Parses a raw glob into an LPEG pattern.
---
--- This uses glob semantics from LSP 3.17.0: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#pattern
---
--- Glob patterns can have the following syntax:
--- - `*` to match one or more characters in a path segment
--- - `?` to match on one character in a path segment
--- - `**` to match any number of path segments, including none
--- - `{}` to group conditions (e.g. `*.{ts,js}` matches TypeScript and JavaScript files)
--- - `[]` to declare a range of characters to match in a path segment (e.g., `example.[0-9]` to match on `example.0`, `example.1`, …)
--- - `[!...]` to negate a range of characters to match in a path segment (e.g., `example.[!0-9]` to match on `example.a`, `example.b`, but not `example.0`)
---
---@param pattern string The raw glob pattern
---@return lpeg.Pattern pattern An LPEG representation of the pattern
function M.to_lpeg(pattern)
    local function class(inv, ranges)
        local patt = R(unpack(tbl_map(table.concat, ranges)))
        if inv == '!' then
            patt = P(1) - patt
        end
        return patt
    end

    local function condlist(conds, after)
        return iter(conds):fold(P(false), function(acc, cond)
            return acc + cond * after
        end)
    end

    local function mul(acc, m)
        return acc * m
    end

    local function star(stars, after)
        return (-after * (P(1) - pathsep)) ^ #stars * after
    end

    local function dstar(after)
        return (-after * P(1)) ^ 0 * after
    end

    local function cut(s, idx, match)
        return idx, match
    end

    local p = P({
        'Pattern',
        Pattern = V('Elem') ^ -1 * V('End'),
        Elem = Cmt(
            Cf(
                (V('DStar') + V('Star') + V('Ques') + V('Class') + V('CondList') + V('Literal'))
                    * (V('Elem') + V('End')),
                mul
            ),
            cut
        ),
        DStar = (B(pathsep) + -B(P(1)))
            * P('**')
            * (pathsep * (V('Elem') + V('End')) + V('End'))
            / dstar,
        Star = C(P('*') ^ 1) * (V('Elem') + V('End')) / star,
        Ques = P('?') * Cc(P(1) - pathsep),
        Class = P('[')
            * C(P('!') ^ -1)
            * Ct(Ct(C(P(1)) * P('-') * C(P(1) - P(']'))) ^ 1 * P(']'))
            / class,
        CondList = P('{') * Ct(V('Cond') * (P(',') * V('Cond')) ^ 0) * P('}') * V('Pattern') / condlist,
        Cond = Cmt(Cf((V('Ques') + V('Class') + V('Literal') - S(',}')) ^ 1, mul), cut) + Cc(P(0)),
        Literal = P(1) / P,
        End = P(-1) * Cc(P(-1)),
    })

    local lpeg_pattern = p:match(pattern)
    assert(lpeg_pattern, 'Invalid glob')
    return lpeg_pattern
end

return M