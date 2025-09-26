
local M = {}


-- Exécute une callback périodiquement tant que le buffer est visible.
-- Redémarre quand le buffer redevient visible.
-- Nettoie tout (timer + autocmd) quand le buffer est détruit.
function M.periodic_cb(bufnr, cb, interval)
  local timer = vim.loop.new_timer()
  local augroup = vim.api.nvim_create_augroup("PeriodicBuf"..bufnr, { clear = true })

  local function start_timer()
    if not timer:is_active() then
      timer:start(
        interval,
        interval,
        vim.schedule_wrap(function()
          if not vim.api.nvim_buf_is_valid(bufnr) then
            -- buffer détruit -> cleanup
            vim.api.nvim_del_augroup_by_id(augroup)
            if not timer:is_closing() then
              timer:stop()
              timer:close()
            end
            return
          end
          local wins = vim.fn.win_findbuf(bufnr)
          if #wins == 0 then
            timer:stop()
            return
          end
          cb()
        end)
      )
    end
  end

  -- stoppe le timer si plus visible
  vim.api.nvim_create_autocmd("BufWinLeave", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      if #vim.fn.win_findbuf(bufnr) == 0 and timer:is_active() then
        timer:stop()
      end
    end,
  })

  -- redémarre si le buffer redevient visible
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        start_timer()
      end
    end,
  })

  -- cleanup complet si le buffer est détruit
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.api.nvim_del_augroup_by_id(augroup)
      if timer:is_active() then
        timer:stop()
      end
      if not timer:is_closing() then
        timer:close()
      end
    end,
  })

  -- lancement initial si déjà visible
  if #vim.fn.win_findbuf(bufnr) > 0 then
    cb()
    start_timer()
  end

  return timer
end

return M


