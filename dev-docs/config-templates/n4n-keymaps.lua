-- ~/n4n-dev/config/nvim/lua/n4n/keymaps.lua
-- O puedes pegar esto al final de tu init.lua
-- Keymaps para menús Telescope N4N por sistema

-- ============================================
-- KEYMAPS N4N: Menús Telescope por sistema
-- ============================================

-- SISTEMAS CLÍNICOS

-- Hemodinamia
vim.keymap.set("n", "<leader>hh", function()
  require("n4n.telescope_systems").open("hemo")
end, { desc = "[N4N] Menú hemodinamia" })

-- Neurológico
vim.keymap.set("n", "<leader>nn", function()
  require("n4n.telescope_systems").open("neuro")
end, { desc = "[N4N] Menú neuro" })

-- Respiratorio
vim.keymap.set("n", "<leader>rr", function()
  require("n4n.telescope_systems").open("resp")
end, { desc = "[N4N] Menú respiratorio" })

-- Infeccioso
vim.keymap.set("n", "<leader>ii", function()
  require("n4n.telescope_systems").open("inf")
end, { desc = "[N4N] Menú infeccioso" })

-- Metabólico/Nutricional
vim.keymap.set("n", "<leader>mm", function()
  require("n4n.telescope_systems").open("meta")
end, { desc = "[N4N] Menú metabólico" })

-- Eliminación
vim.keymap.set("n", "<leader>ee", function()
  require("n4n.telescope_systems").open("elim")
end, { desc = "[N4N] Menú eliminación" })

-- Dolor y Confort
vim.keymap.set("n", "<leader>dd", function()
  require("n4n.telescope_systems").open("dolor")
end, { desc = "[N4N] Menú dolor y confort" })

-- Oncológico/Terapias especiales
vim.keymap.set("n", "<leader>oo", function()
  require("n4n.telescope_systems").open("onco")
end, { desc = "[N4N] Menú oncológico" })

-- EXAMEN FÍSICO Y PLAN

-- Examen físico segmentado
vim.keymap.set("n", "<leader>xf", function()
  require("n4n.telescope_systems").open("ef")
end, { desc = "[N4N] Examen físico segmentado" })

-- Pendientes / Plan de cuidados
vim.keymap.set("n", "<leader>xp", function()
  require("n4n.telescope_systems").open("plan")
end, { desc = "[N4N] Pendientes / Plan" })

-- ============================================
-- RESUMEN DE KEYMAPS N4N
-- ============================================
--
-- SISTEMAS (doble letra):
--   <leader>hh  →  Hemodinamia
--   <leader>nn  →  Neurológico
--   <leader>rr  →  Respiratorio
--   <leader>ii  →  Infeccioso
--   <leader>mm  →  Metabólico/Nutricional
--   <leader>ee  →  Eliminación
--   <leader>dd  →  Dolor y confort
--   <leader>oo  →  Oncológico
--
-- EXAMEN FÍSICO Y PLAN (x + letra):
--   <leader>xf  →  Examen físico
--   <leader>xp  →  Pendientes/Plan
--
-- NOTA: Si <leader> es espacio (default), entonces:
--   Espacio + h + h  →  menú hemodinamia
--   Espacio + n + n  →  menú neuro
--   etc.
--
-- ============================================
