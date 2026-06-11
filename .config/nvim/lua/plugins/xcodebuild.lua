-- build, run, test, and debug Apple-platform apps (iOS, macOS, ...) from Neovim
local M = {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim",
    "stevearc/oil.nvim",
  },
  ft = { "swift", "objc" },
  cmd = { "XcodebuildSetup", "XcodebuildPicker" },
  keys = {
    { "<leader>Xl", "<cmd>XcodebuildPicker<cr>", desc = "All Actions" },
    { "<leader>Xf", "<cmd>XcodebuildProjectManager<cr>", desc = "Project Manager" },
    { "<leader>Xb", "<cmd>XcodebuildBuild<cr>", desc = "Build" },
    { "<leader>XB", "<cmd>XcodebuildBuildForTesting<cr>", desc = "Build For Testing" },
    { "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Build & Run" },
    { "<leader>Xt", "<cmd>XcodebuildTest<cr>", desc = "Run Tests" },
    { "<leader>XT", "<cmd>XcodebuildTestClass<cr>", desc = "Run Test Class" },
    { "<leader>X.", "<cmd>XcodebuildTestRepeat<cr>", desc = "Repeat Last Tests" },
    { "<leader>Xe", "<cmd>XcodebuildTestExplorerToggle<cr>", desc = "Test Explorer" },
    { "<leader>Xs", "<cmd>XcodebuildSelectScheme<cr>", desc = "Select Scheme" },
    { "<leader>Xd", "<cmd>XcodebuildSelectDevice<cr>", desc = "Select Device" },
    { "<leader>Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "Toggle Code Coverage" },
    { "<leader>XC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", desc = "Code Coverage Report" },
    { "<leader>Xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", desc = "Generate Preview" },
    { "<leader>X<cr>", "<cmd>XcodebuildPreviewToggle<cr>", desc = "Toggle Preview" },
    { "<leader>Xx", "<cmd>XcodebuildToggleLogs<cr>", desc = "Toggle Logs" },
    { "<leader>Xq", "<cmd>XcodebuildQuickfixLine<cr>", desc = "Quickfix Line" },
    { "<leader>Xa", "<cmd>XcodebuildCodeActions<cr>", desc = "Code Actions" },
    -- debugging through nvim-dap (Xcode 16+ ships lldb-dap; no codelldb needed)
    { "<leader>XD", function() require("xcodebuild.integrations.dap").build_and_debug() end, desc = "Build & Debug" },
    { "<leader>XR", function() require("xcodebuild.integrations.dap").debug_without_build() end, desc = "Debug Without Building" },
    { "<leader>XE", function() require("xcodebuild.integrations.dap").debug_tests() end, desc = "Debug Tests" },
    { "<leader>XQ", function() require("xcodebuild.integrations.dap").terminate_session() end, desc = "Terminate Debugger" },
  },
}

function M.config()
  require("xcodebuild").setup({
    show_build_progress_bar = true,
    integrations = {
      -- regenerates buildServer.json when the scheme changes, keeping sourcekit-lsp in sync
      xcode_build_server = { enabled = true },
      -- file operations in oil update the Xcode project (requires xcp)
      oil_nvim = { enabled = true },
      nvim_tree = { enabled = false },
      neo_tree = { enabled = false },
    },
  })

  require("xcodebuild.integrations.dap").setup()
end

return M
