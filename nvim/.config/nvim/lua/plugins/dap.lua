-- ~/.config/nvim/lua/plugins/dap.lua
-- Instalar debugers necesarios con `:Mason` (ej: debugpy)
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"nvim-neotest/nvim-nio",
		},
		-- Solo cargamos el plugin cuando presionamos una de estas teclas
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start/Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>dr",
				function()
					require("dap-python").test_method()
				end,
				desc = "Debug: Python Test Method",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dappython = require("dap-python")

			-- 1. Estética Moderna (Highlights y Signs)
			local signs = {
				DapBreakpoint = { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" },
				DapBreakpointCondition = { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" },
				DapLogPoint = { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" },
				DapStopped = { text = "󰁕", texthl = "DapStopped", linehl = "debugPC", numhl = "DapStopped" },
				DapBreakpointRejected = { text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" },
			}

			-- Colores (Modern UI)
			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e06c75" })
			vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bold = true })

			for name, config in pairs(signs) do
				vim.fn.sign_define(name, config)
			end

			-- 2. Configurar UI
			dapui.setup()

			-- Automatización de apertura/cierre de ventanas
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- 3. Configuración de Python (Smart Detection para v0.12)
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			dappython.setup(mason_path)

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file (Venv Detection)",
					program = "${file}",
					pythonPath = function()
						-- Busca venv en el directorio actual o hacia arriba
						local venv = vim.fs.find({ "venv", ".venv" }, { upward = true, type = "directory" })[1]
						if venv then
							return venv .. "/bin/python"
						end
						return "/usr/bin/python3" -- Fallback global de Arch
					end,
				},
			}
		end,
	},
}
