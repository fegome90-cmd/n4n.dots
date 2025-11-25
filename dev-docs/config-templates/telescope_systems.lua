-- ~/n4n-dev/config/nvim/lua/n4n/telescope_systems.lua
-- Módulo de menús Telescope por sistema para N4N
-- Versión: PDF 3000 normalidad + expansión futura patología

local M = {}

-- Base de datos de sistemas y sus plantillas
-- Cada entrada tiene:
--   - label: texto descriptivo que aparece en el menú
--   - snippet_prefix: código de 3 letras que se inserta al seleccionar
local systems = {
  hemo = {
    { label = "Hemodinamia normal estable", snippet_prefix = "hst" },
    -- Futuro: agregar plantillas patológicas aquí
    -- { label = "Shock séptico + noradrenalina", snippet_prefix = "shock-septico" },
    -- { label = "Hipotensión post-sedación", snippet_prefix = "hipo-sed" },
    -- { label = "PA elevada + antihipertensivo", snippet_prefix = "hta-desa" },
  },

  neuro = {
    { label = "Neurológico basal normal", snippet_prefix = "nbo" },
    -- Futuro:
    -- { label = "Glasgow alterado", snippet_prefix = "glasgow-alt" },
    -- { label = "Pupilas asimétricas", snippet_prefix = "pupilas-asim" },
    -- { label = "Déficit motor focal", snippet_prefix = "deficit-motor" },
  },

  resp = {
    { label = "Respiratorio dentro de metas", snippet_prefix = "rst" },
    -- Futuro:
    -- { label = "SDRA + ventilación prono", snippet_prefix = "sdra-prono" },
    -- { label = "Destete progresivo de VM", snippet_prefix = "destete-vm" },
    -- { label = "Broncoespasmo + broncodilatadores", snippet_prefix = "bronco" },
  },

  inf = {
    { label = "Infeccioso sin foco activo", snippet_prefix = "ist" },
    -- Futuro:
    -- { label = "Sepsis + cultivos pendientes", snippet_prefix = "sepsis-cult" },
    -- { label = "Foco respiratorio + ATB", snippet_prefix = "foco-resp" },
    -- { label = "Foco urinario + ATB", snippet_prefix = "foco-urin" },
  },

  meta = {
    { label = "Metabólico/nutricional compensado", snippet_prefix = "mst" },
    -- Futuro:
    -- { label = "Hiperglicemia descompensada", snippet_prefix = "hiper-glic" },
    -- { label = "Acidosis metabólica", snippet_prefix = "acidosis" },
    -- { label = "Hipokalemia + reposición", snippet_prefix = "hipo-k" },
  },

  elim = {
    { label = "Eliminación conservada", snippet_prefix = "elm" },
    -- Futuro:
    -- { label = "Oliguria + furosemida", snippet_prefix = "oliguria" },
    -- { label = "IRA + hemodiálisis", snippet_prefix = "ira-hd" },
    -- { label = "Retención urinaria", snippet_prefix = "retencion" },
  },

  dolor = {
    { label = "Dolor controlado y confort adecuado", snippet_prefix = "dst" },
    -- Futuro:
    -- { label = "Dolor intenso refractario", snippet_prefix = "dolor-refract" },
    -- { label = "Sedación profunda RASS -4/-5", snippet_prefix = "sedacion-prof" },
    -- { label = "Delirium agitado", snippet_prefix = "delirium" },
  },

  onco = {
    { label = "Situación oncológica estable", snippet_prefix = "ost" },
    -- Futuro:
    -- { label = "Neutropenia febril", snippet_prefix = "neutro-febril" },
    -- { label = "Síndrome de lisis tumoral", snippet_prefix = "lisis-tumor" },
    -- { label = "Mucositis grado 3-4", snippet_prefix = "mucositis" },
  },

  ef = {
    { label = "Examen físico segmentado normal", snippet_prefix = "efn" },
    -- Futuro:
    -- { label = "LPP grado II sacra", snippet_prefix = "lpp-sacra" },
    -- { label = "Edema EEII 2+/4+", snippet_prefix = "edema-eeii" },
  },

  plan = {
    { label = "Pendientes / Plan estándar", snippet_prefix = "pen" },
    -- Futuro: planes específicos por patología
  },
}

-- Función principal: abre menú Telescope para un sistema específico
-- @param system_key string: clave del sistema (hemo, neuro, resp, etc.)
function M.open(system_key)
  -- Verificar que Telescope esté disponible
  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    vim.notify("Telescope no disponible. Instala con :Lazy", vim.log.levels.ERROR)
    return
  end

  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  -- Obtener plantillas del sistema solicitado
  local items = systems[system_key]
  if not items then
    vim.notify("Sistema no definido: " .. tostring(system_key), vim.log.levels.ERROR)
    return
  end

  -- Crear picker de Telescope
  pickers
    .new({}, {
      prompt_title = "Sistema " .. system_key:upper() .. " (N4N)",
      finder = finders.new_table({
        results = items,
        entry_maker = function(item)
          return {
            value = item,
            display = item.label .. " [" .. item.snippet_prefix .. "]",
            ordinal = item.label .. " " .. item.snippet_prefix,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(_, map)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        -- Acción al presionar Enter: insertar prefijo del snippet
        local insert_snippet_prefix = function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if not selection or not selection.value then
            return
          end

          -- Insertar el prefijo en el buffer actual
          local prefix = selection.value.snippet_prefix
          vim.api.nvim_put({ prefix }, "c", true, true)

          -- Nota: el usuario deberá presionar Tab para expandir el snippet
          -- Esto mantiene el flujo: menú → prefijo → Tab → expansión
          -- Más adelante podemos automatizar esto con LuaSnip.expand()
        end

        -- Mapear Enter en modo insert y normal
        map("i", "<CR>", insert_snippet_prefix)
        map("n", "<CR>", insert_snippet_prefix)
        return true
      end,
    })
    :find()
end

return M
