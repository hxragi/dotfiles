local capabilities = require("lsp.capabilities")

local servers = {
  "rust_analyzer",
  "jdtls",
  "lua_ls",
  "basedpyright",
  "ruff",
  "yamlls",
  "nixd",
  "solidity_ls",
  "forge_lsp",
}

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("forge_lsp", {
  cmd = { "forge", "lsp" },
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
})

local function generate_ide_files_for_dir(root)
  local project_file = root .. "/.project"
  local classpath_file = root .. "/.classpath"
  local src_dir = root .. "/src/main/java"

  if not vim.uv.fs_stat(src_dir) then
    return
  end

  local project_name = vim.fs.basename(root)

  if not vim.uv.fs_stat(project_file) then
    local proj = string.format(
      [[<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
	<name>%s</name>
	<comment></comment>
	<projects>
	</projects>
	<buildSpec>
		<buildCommand>
			<name>org.eclipse.jdt.core.javabuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
	</buildSpec>
	<natures>
		<nature>org.eclipse.jdt.core.javanature</nature>
	</natures>
</projectDescription>
]],
      project_name
    )
    local f = io.open(project_file, "w")
    if f then
      f:write(proj)
      f:close()
    end
  end

  local repo_root = vim.fs.root(root, { ".git", "MODULE.bazel" }) or root
  local bazel_maven_dir = repo_root .. "/bazel-bin/external/rules_jvm_external++maven+maven"

  local jars = {}
  if vim.uv.fs_stat(bazel_maven_dir) then
    local found = vim.fs.find(function(name)
      return name:match("^processed_.*%.jar$")
    end, { path = bazel_maven_dir, limit = 500, type = "file" })
    for _, j in ipairs(found) do
      table.insert(jars, j)
    end
    table.sort(jars)
  end

  local lines = {
    '<?xml version="1.0" encoding="UTF-8"?>',
    "<classpath>",
    '\t<classpathentry kind="src" output="bin/main" path="src/main/java"/>',
  }
  if vim.uv.fs_stat(root .. "/src/main/resources") then
    table.insert(
      lines,
      '\t<classpathentry kind="src" output="bin/main" path="src/main/resources"/>'
    )
  end
  if vim.uv.fs_stat(root .. "/src/test/java") then
    table.insert(lines, '\t<classpathentry kind="src" output="bin/test" path="src/test/java"/>')
  end
  table.insert(
    lines,
    '\t<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-25/"/>'
  )
  for _, jar in ipairs(jars) do
    table.insert(lines, string.format('\t<classpathentry kind="lib" path="%s"/>', jar))
  end
  table.insert(lines, '\t<classpathentry kind="output" path="bin/default"/>')
  table.insert(lines, "</classpath>\n")

  local f = io.open(classpath_file, "w")
  if f then
    f:write(table.concat(lines, "\n"))
    f:close()
  end
end

local function ensure_java_ide_files(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" or not file:match("%.java$") then
    return
  end

  local root = vim.fs.root(file, { ".project", "src", "build.gradle", "pom.xml", "BUILD.bazel" })
  if root then
    generate_ide_files_for_dir(root)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(args)
    ensure_java_ide_files(args.buf)
  end,
})

vim.lsp.config("jdtls", {
  root_markers = {
    { ".project", "src" },
    { "build.gradle", "build.gradle.kts", "pom.xml" },
    { "BUILD.bazel" },
    { "settings.gradle", "settings.gradle.kts", ".git" },
  },
  before_init = function(_, config)
    if config.root_dir then
      local bufnr = vim.api.nvim_get_current_buf()
      ensure_java_ide_files(bufnr)
    end
  end,
})

vim.api.nvim_create_user_command("JdtlsSync", function()
  local repo_root = vim.fs.root(0, { ".git", "MODULE.bazel" }) or vim.uv.cwd()
  local src_dirs = vim.fs.find("src", { path = repo_root, limit = 100, type = "directory" })
  local count = 0
  for _, s in ipairs(src_dirs) do
    local mod_root = vim.fs.dirname(s)
    if vim.uv.fs_stat(mod_root .. "/src/main/java") then
      generate_ide_files_for_dir(mod_root)
      count = count + 1
    end
  end
  vim.notify(
    string.format("Synced %d Java modules with Bazel dependencies", count),
    vim.log.levels.INFO
  )
  vim.cmd("LspRestart jdtls")
end, { desc = "Sync all Java projects with Bazel dependencies and restart JDTLS" })

vim.api.nvim_create_user_command("JdtlsClean", function()
  local cache_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace"
  vim.fn.delete(cache_dir, "rf")
  vim.notify("JDTLS workspace cache cleared", vim.log.levels.INFO)
  vim.cmd("LspRestart jdtls")
end, { desc = "Clear JDTLS workspace cache and restart" })

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.enable(servers)
