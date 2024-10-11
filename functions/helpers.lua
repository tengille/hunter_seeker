-- https://stackoverflow.com/a/7153689
-- print with no newline character (akin to Ruby)
-- local write = io.write
-- function print(...)
--   local n = select("#", ...)
--   for i = 1, n do
--     local v = tostring(select(i, ...))
--     write(v)
--     if i ~= n then write '\t' end
--   end
-- end

-- -- print with a newline character (akin to Ruby)
-- function puts(...)
--   local n = select("#", ...)
--   for i = 1, n do
--     local v = tostring(select(i, ...))
--     write(v)
--     if i ~= n then write '\t' end
--   end
--   write '\n'
-- end

-- used for rounding numbers
function round(number, decimal_places)
  local mult = 10^(decimal_places or 0)
  return math.floor(number * mult + 0.5) / mult
end
