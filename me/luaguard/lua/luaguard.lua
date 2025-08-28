local M = {}

-- Utilities
local function normalize_path(path)
  return vim.fn.resolve(vim.fn.fnamemodify(path, ':p'))
end

M.config = {
  -- Projects storage file (in nvim config directory)
  safe_cache_path = vim.fn.stdpath('data') .. '/luaguard.json',
}

---@type table<string, string>
local cache = {}


---@return table<string, string>
local function load_cache()
  local file = io.open(M.config.safe_cache_path, 'r')
  if file then
    local content = file:read('*all')
    file:close()
    local success, data = pcall(vim.json.decode, content)
    if success and type(data) == 'table' then
      cache = data
    end
  end
end

local function save_cache()
  local file = io.open(M.config.safe_cache_path, 'w')
  if file then
    file:write(vim.json.encode(cache))
    file:close()
  else
    vim.notify('Cannot write safe files cache: ' .. M.config.safe_cache_path, vim.log.levels.ERROR)
  end
end

---@param filepath string
---@return string checksum
---@return string content
function M.file_checksum_nvim(filepath)
  -- Vérifier si le fichier existe
  if vim.fn.filereadable(filepath) == 0 then
      return nil, "Fichier non lisible"
  end
  
  -- Lire tout le fichier
  local lines = vim.fn.readfile(filepath, 'b') -- 'b' pour binaire
  local content = table.concat(lines, '\n')
  
  return vim.fn.sha256(content), content
end

---@param path string
function M.source(path)
  path = normalize_path(path)
  local checksum, content = M.file_checksum_nvim(path)
  --print('TTT SafeSource ' .. vim.inspect({path=path, checksum=checksum, current=cache[path]}))
  local function after()
    print('TTT LOAD content\n')
    print(content)
    load(content)()
  end
  if cache[path] ~= checksum then
    vim.ui.input(
      { prompt = 'The file ' .. path .. ' is not yet trusted (never executed or changed since last time). Answer "yes" to proceed sourcing: ' },
      function(input)
        if input ~= 'yes' then
          return
        end
        cache[path] = checksum
        save_cache()
        after()
      end
    )
  else
    after()
  end
end


-- Setup and initialization
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_extend('force', M.config, opts)
  load_cache()
  
  vim.api.nvim_create_user_command('SafeLuado', function(cmd)
  --print('TTT SafeSourceCmd ' .. vim.inspect({cmd=cmd}))
    M.source(cmd.fargs[1])
  end, {
    nargs = '?',
    desc = "Source a lua file, but ask the user before if it's the first time"
  })

end
return M
