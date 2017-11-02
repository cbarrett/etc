trie = {}

trie.mt = {}
trie.tombstone = {}
function trie.mt:__index(k)
  local v 
  if k == "" then
    v = rawget(self,"__value")
    if v == trie.tombstone then
      v = nil
    end
  else
    v = rawget(self,k) or rawget(trie,k)
  end
  return v
end
function trie.mt:__newindex(k,v)
  if k == "" then
    k = "__value"
  end
  rawset(self,k,v)
end
function trie.mt.__concat(lhs,rhs)
  if type(lhs) == "table" and type(rhs) == table then
    return lhs.flatmap(function(_) return rhs end)
  elseif type(lhs) == "string" then
    -- Should this split every character or should we make it a radix trie?
    local rest, r = rsplit(lhs)
    local new = trie.empty() 
    new[r] = self
    if rest then
      return rest .. new
    else
      return new
    end
  elseif type(rhs) == "string" then
    -- TODO
  end
end
trie.__index = trie
setmetatable(trie,trie.mt)

function trie.empty()
  local new = {__value=trie.tombstone}
  setmetatable(new,trie)
  return new
end
function trie.singleton(v)
  local new = trie.empty()
  if v then
    new[""] = v
  end
  return new
end
function trie:flatmap(f)
  local v = self[""]
  local new = v and f(v) or trie.empty()
  assert(new.mt == trie.mt)
  setmetatable(new,self)
  for k,t in pairs(new) do
    if utf8.len(k) == 1 and t.mt == trie.mt then
      new[k] = t:flatmap(f)
    end
  end
  return new
end
function trie:map(f)
  return self:flatmap(function(x) return trie.singleton(f(x)) end)
end

function rsplit(str)
  local last = utf8.offset(str,-1)
  if last == nil then
    return nil, nil
  else 
    function get(i,j)
      if j < i then
        return nil
      else
        return string.sub(str,i,j)
      end
    end
    return get(1,last-1), get(last,#str)
  end
end
function lsplit(str)
  -- TODO
end

