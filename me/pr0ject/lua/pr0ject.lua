-- Simple Project Manager for Neovim

local M = {}

-- Configuration
M.config = {
  -- Projects storage file (in nvim config directory)
  projects_file = vim.fn.stdpath('data') .. '/pr0jects.json',
  -- Hook called on project change
  on_before_project_change = nil,
  on_project_change = nil,
}

---@class Project
---@field name string
---@field path string
local Project = {}
Project.__index = Project

function Project:new(path, name)
  local instance = setmetatable({}, self)
  instance.path = path
  if name == nil or name == '' then
    instance.name = vim.fn.fnamemodify(path, ':t')
  else
    instance.name = name
  end
  return instance
end

local migrate_steps = {
  -- 1
  function(_projects)
    local res = {
      version = 1,
      projects = {}
    }
    for _, p in pairs(_projects) do
      table.insert(res.projects, p)
    end
    return res
  end,
}

local function migrate(_projects)
  local version = _projects.version or 0
  migrated = (version < #migrate_steps)
  while version < #migrate_steps do
    _projects = migrate_steps[version + 1](_projects)
    version = _projects.version
  end
  return _projects, migrated
end


-- Internal state
-- path -> Project
---@type table<string, Project>
local projects = {}
---@type Project[]
local ordered_projects = {}

-- Utilities
local function normalize_path(path)
  return vim.fn.resolve(vim.fn.fnamemodify(path, ':p:h'))
end

local function save_projects()
  local file = io.open(M.config.projects_file, 'w')
  if file then
    file:write(vim.json.encode({
      version = #migrate_steps,
      projects = ordered_projects,
    }))
    file:close()
  else
    vim.notify('Cannot write projects file: ' .. M.config.projects_file, vim.log.levels.ERROR)
  end
end


---@return table<string, Project>
local function load_projects()
  local file = io.open(M.config.projects_file, 'r')
  if file then
    local content = file:read('*all')
    file:close()
    local success, data = pcall(vim.json.decode, content)
    if success and type(data) == 'table' then
      local migrated_data, migrated = migrate(data)
      projects = {}
      ordered_projects = {}
      for _, p in ipairs(migrated_data.projects) do
        table.insert(ordered_projects, p)
        projects[p.path] = p
      end
    end
    if migrated then
      save_projects()
    end

  end
end

local function project_exists(path)
  load_projects()
  return projects[path] ~= nil
end

---@param name string
---@return Project[]
local function get_projects_by_name(name)
  load_projects()
  local matches = {}
  for _, project in pairs(projects) do
    if project.name == name then
      table.insert(matches, project)
    end
  end
  return matches
end

---@param path string
---@return Project
local function get_project_by_path(path)
  load_projects()
  path = normalize_path(path)
  return projects[path]
end

-- Main functions
---@param path string
---@param name string 
function M.add_project(path, name)
  path = path or vim.fn.getcwd()
  path = normalize_path(path)

  local function after_name_ok()
    load_projects()
    if project_exists(path) then
      vim.notify('Project already exists: ' .. path .. '. Renaming.', vim.log.levels.WARN)
    end
    
    local project = Project:new(path, name)
    projects[path] = project
    table.insert(ordered_projects, project)
    
    save_projects()
    
    vim.notify('Project added: ' .. project.name .. ' -> ' .. project.path)
  end
  
  -- Ask for name if it's empty
  if name == nil then
    vim.ui.input(
      { prompt = 'Project name (default: ' .. vim.fn.fnamemodify(path, ':t') .. '): ' },
      function(input)
        if input == nil then
          return
        end
        name = input
        after_name_ok()
      end
    )
  else
    after_name_ok()
  end
end

function M.remove_project_by_path(path)
  load_projects()
  path = normalize_path(path)
  
  local project = get_project_by_path(path)
  if project ~= nil then
    projects[path] = nil
    for index, p in ipairs(ordered_projects) do
      if p.path == path then
        table.remove(ordered_projects, index)
        break
      end
    end
    save_projects()
    vim.notify('Project removed: ' .. project.name .. ' (' .. project.path .. ')')
    return true
  end
  
  vim.notify('No project found for path: ' .. path, vim.log.levels.WARN)
  return false
end

---@param identifier string|nil 
---@return boolean
function M.remove_project(identifier)
  load_projects()
  if not identifier or identifier == '' then
    -- No identifier provided, use current directory
    return M.remove_project_by_path(vim.fn.getcwd())
  end
  
  -- Check if it's a path (contains / or \)
  if string.match(identifier, '[/\\]') then
    return M.remove_project_by_path(identifier)
  end
  
  -- It's a name, find matching projects
  local matches = get_projects_by_name(identifier)
  
  if #matches == 0 then
    vim.notify('No project found with name or path: ' .. identifier, vim.log.levels.WARN)
    return false
  elseif #matches == 1 then
    -- Single match, remove it
    return M.remove_project_by_path(matches[1].path)
  else
    -- Multiple matches, show interactive menu
    local choices = {}
    for _, match in ipairs(matches) do
      table.insert(
        choices,
        match
      )
    end

    vim.ui.select(
      choices,
      {
        prompt = 'Multiple projects with name "' .. identifier .. '":',
        format_item = function(item)
          return string.format('%s (%s)', item.name, item.path)
        end
      },
      function(choice)
        if choice == nil then
          return
        end
        local selected = choice
        return M.remove_project_by_path(selected.path)
      end
    )
  end
end

function M.switch_to_project(project_path)
  load_projects()
  project_path = normalize_path(project_path)

  if projects[project_path] ~= nil then
    for index, p in ipairs(ordered_projects) do
      if p.path == project_path then
        table.insert(ordered_projects, table.remove(ordered_projects, index))
        break
      end
    end
  end

  save_projects()
  
  if M.config.on_project_change then
    local allow_continue = M.config.on_before_project_change(project_path)
    if allow_continue == false then
      return
    end
  end
  
  -- Trigger autocmd DirChanged
  vim.api.nvim_exec_autocmds('User', { pattern = 'BeforeProjectChanged' })
  
  -- Close all buffers
  vim.cmd('%bd')
  
  -- Change working directory
  vim.fn.chdir(project_path)
  
  -- Call hook if defined
  if M.config.on_project_change then
    M.config.on_project_change(project_path)
  end
  
  -- Trigger autocmd DirChanged
  vim.api.nvim_exec_autocmds('User', { pattern = 'ProjectChanged' })
end

-- Generic function to get projects list
function M.get_projects_list()
  load_projects()
  local project_list = {}
  for _, project in pairs(projects) do
    table.insert(project_list, {
      name = project.name,
      path = project.path,
      display = project.name .. ' (' .. project.path .. ')',
    })
  end
  return project_list
end

-- Telescope integration
function M.telescope_projects()
  load_projects()
  local has_telescope, telescope = pcall(require, 'telescope')
  if not has_telescope then
    vim.notify('Telescope is not installed', vim.log.levels.ERROR)
    return
  end
  
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local sorters = require('telescope.sorters')
  
  if next(projects) == nil then
    vim.notify('No projects found', vim.log.levels.WARN)
    return
  end
  
  local function project_list()
    local res = {}
    for index, project in ipairs(ordered_projects) do
      table.insert(res, {
        path = project.path,
        name = project.name,
        index = index,
      })
    end
    return res
  end
  
  local custom_sorter = sorters.new({
    scoring_function = function(_, prompt, line, entry)
      if prompt == "" then
        -- No search, use original index
        return -entry.value.index
      else
        -- active research, use default search
        return sorters.get_fzy_sorter().scoring_function(_, prompt, line)
      end
    end,
    
    highlighter = function(_, prompt, display)
      if prompt == "" then
        return {}
      else
        return sorters.get_fzy_sorter().highlighter(_, prompt, display)
      end
    end,
  })
  
  pickers.new({}, {
    prompt_title = 'Projects',
    finder = finders.new_table({
      results = project_list(),
      entry_maker = function(project)
        return {
          value = project,
          display = project.name .. ' (' .. project.path .. ')',
          ordinal = project.name .. ' ' .. project.path,
        }
      end,
    }),
    sorter = custom_sorter,
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        M.switch_to_project(selection.value.path)
      end)
      
      -- Mapping to remove project (Ctrl-d)
      map('i', '<C-d>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        M.remove_project_by_path(selection.value.path)
        -- Relaunch picker
        vim.defer_fn(M.telescope_projects, 100)
      end)
      
      return true
    end,
  }):find()
end

function M.list_projects()
  load_projects()
  if next(projects) == nil then
    vim.notify('No projects found')
    return
  end
  
  print('Registered projects:')
  for _, project in pairs(projects) do
    print('  ' .. project.name .. ' -> ' .. project.path)
  end
end

-- Setup and initialization
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_extend('force', M.config, opts)
  
  load_projects()
  
  -- Commands
  vim.api.nvim_create_user_command('ProjectAdd', function(cmd)
    M.add_project(vim.fn.getcwd(), cmd.fargs[1])
  end, { 
    nargs = '?',
    desc = 'Add current directory as project'
  })
  
  vim.api.nvim_create_user_command('ProjectRemove', function(cmd)
    M.remove_project(cmd.args)
  end, { 
    nargs = '?',
    desc = 'Remove project by name or path'
  })
  
  vim.api.nvim_create_user_command('ProjectList', function()
    M.list_projects()
  end, {
    desc = 'List all projects'
  })
  
  vim.api.nvim_create_user_command('ProjectSwitch', function()
    M.telescope_projects()
  end, {
    desc = 'Switch to project via Telescope'
  })
end

function M.inspect()
  return vim.inspect(projects) .. '\n' .. vim.inspect(ordered_projects)
end

return M
